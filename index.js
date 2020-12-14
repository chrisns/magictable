const AWS = require('aws-sdk')
const { JSDOM } = require('jsdom')

const ApiBuilder = require('claudia-api-builder')
const api = new ApiBuilder()

const fetch = require('node-fetch')
const handler = (domain, a, b, url) => {
  return fetch(url)
    .then(res => res.text())
    .then(res => new JSDOM(res, { pretendToBeVisual: true }))
    .then(dom => {
      const jQuery = (require('jquery'))(dom.window)

      const base = dom.window.document.createElement('base')
      base.setAttribute('href', url)
      const script = dom.window.document.createElement('script')

      script.appendChild(dom.window.document.createTextNode('setInterval(function () { jQuery("table.table").load(`${window.location.href}?${Math.floor(Date.now()/1000)} table.table`) }, 1000)')) // eslint-disable-line no-template-curly-in-string

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
}
api.get('/{domain}/{a}/{b}/{base}', function (request) {
  return handler(request.pathParams.domain, request.pathParams.a, request.pathParams.b, decodeURIComponent(request.pathParams.base))
})

api.get('/{domain}', function () {
  return `<html><body>
<form onsubmit="window.location = window.location + '/' + document.forms[0].elements.a.value + '/' + document.forms[0].elements.b.value + '/' + encodeURIComponent(document.forms[0].elements.base.value); return false">
<label for="a">a:</label>
<input type="number" id="a" name="a" min="1" max="100"><br><br>
<label for="b">b:</label>
<input type="number" id="b" name="b" min="1" max="100"><br><br>
<label for="base">Base</label>
<select name="base" id="base">
  <option selected="selected" value="https://www.rottentomatoes.com/top/bestofrt/">https://www.rottentomatoes.com/top/bestofrt/ - current</option>
  <option value="http://demo.zoomfab.info/21-07-2020.html">https://www.rottentomatoes.com/top/bestofrt/ - 21-07-2020</option>
  <option value="http://demo.zoomfab.info/06-11-2020.html">https://www.rottentomatoes.com/top/bestofrt/ - 06-11-2020</option>
  <option value="http://demo.zoomfab.info/14-12-2020.html">https://www.rottentomatoes.com/top/bestofrt/ - 14-12-2020</option>
</select>
<br><br>
<input type="submit" value="Submit">
</body></html>`
}, { success: { contentType: 'text/html' } })

module.exports = api
