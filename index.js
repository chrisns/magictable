const AWS = require('aws-sdk')
const { JSDOM } = require('jsdom')

const ApiBuilder = require('claudia-api-builder')
const api = new ApiBuilder()

const fetch = require('node-fetch')
const handler = (domain, a, b, url) => {
  return fetch(url, { headers: { "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15" } })
    .then(res => res.text())
    .then(res => new JSDOM(res, { pretendToBeVisual: true }))
    .then(dom => {
      const jQuery = (require('jquery'))(dom.window)

      const base = dom.window.document.createElement('base')
      base.setAttribute('href', url)
      const script = dom.window.document.createElement('script')

      script.appendChild(dom.window.document.createTextNode('var thetimer = setInterval(function () { jQuery("table.table").load(`${window.location.href}?${Math.floor(Date.now()/1000)} table.table`) }, 1000); setTimeout(function() {clearInterval(thetimer)}, 1000*60*60*4)')) // eslint-disable-line no-template-curly-in-string

      dom.window.document.head.appendChild(base)
      dom.window.document.body.appendChild(script)

      const newa = jQuery(`table.table tr:nth-child(${a}) td:nth-child(3)`).html().toString()
      const newb = jQuery(`table.table tr:nth-child(${b}) td:nth-child(3)`).html().toString()

      jQuery(`table.table tr:nth-child(${a}) td:nth-child(3)`).html(newb)
      jQuery(`table.table tr:nth-child(${b}) td:nth-child(3)`).html(newa)
      return dom
    })
    .then(dom => dom.serialize())
    .then(html => {
      const s3 = new AWS.S3({
        params: {
          Bucket: domain,
          Key: 'index.html',
          ContentType: 'text/html'
        }
      })
      return s3.putObject({ Body: html }).promise()
    })
    .then(response => {
      return `<html><body><h1>Done! <a href="#" onClick="window.history.back(); return false">Go back to adjuster</a></h1><pre>${JSON.stringify(response)}</pre></body></html>`
    })
}
api.get('/{domain}/{a}/{b}/{base}', function (request) {
  return handler(request.pathParams.domain, request.pathParams.a, request.pathParams.b, decodeURIComponent(request.pathParams.base))
}, { success: { contentType: 'text/html' } })

api.get('/{domain}', function (request) {
  return `<html><body>
<form onsubmit="window.open('http://${request.pathParams.domain}'); window.location = window.location + '/' + document.forms[0].elements.a.value + '/' + document.forms[0].elements.b.value + '/' + encodeURIComponent(document.forms[0].elements.base.value); return false">
<label for="a">Original Position:</label>
<input type="number" id="a" name="a" min="1" max="100" value="1"><br><br>
<label for="b">Swap with (Spectator choice):</label>
<input type="number" id="b" name="b" min="1" max="100" value="1"><br><br>
<label for="base">Base</label>
<select name="base" id="base">
  <option selected="selected" value="https://www.rottentomatoes.com/top/bestofrt/">https://www.rottentomatoes.com/top/bestofrt/ - current</option>
  <option value="http://demo.zoomfab.info/21-07-2020.html">https://www.rottentomatoes.com/top/bestofrt/ - 21-07-2020</option>
  <option value="http://demo.zoomfab.info/06-11-2020.html">https://www.rottentomatoes.com/top/bestofrt/ - 06-11-2020</option>
  <option value="http://demo.zoomfab.info/14-12-2020.html">https://www.rottentomatoes.com/top/bestofrt/ - 14-12-2020</option>
  <option value="http://demo.zoomfab.info/20-02-2021.html">https://www.rottentomatoes.com/top/bestofrt/ - 20-02-2020</option>
</select>
<br><br>
<input type="submit" value="Submit">
</body></html>`
}, { success: { contentType: 'text/html' } })

module.exports = api
handler("foo.com", 1, 1, "https://www.rottentomatoes.com/top/bestofrt/")