const AWS = require('aws-sdk')
const { JSDOM } = require("jsdom");
const s3 = new AWS.S3({
  params: {
    Bucket: 'www.rotten100.com',
    Key: 'index.html',
    ContentType: 'text/html'
  }
})

const ApiBuilder = require('claudia-api-builder')
const api = new ApiBuilder()

const fetch = require("node-fetch");
const url = "https://www.rottentomatoes.com/top/bestofrt/"
const handler = (a,b) => fetch(url)
.then(res => res.text())
.then(res => new JSDOM(res, { pretendToBeVisual: true }))
.then(dom => { 
  const jQuery = (require('jquery'))(dom.window);

  const base = dom.window.document.createElement("base")
  base.setAttribute('href', url)
  const script = dom.window.document.createElement("script")

  script.appendChild(dom.window.document.createTextNode('setInterval(function () { jQuery("table.table").load(`${window.location.href}?${Math.floor(Date.now()/1000)} table.table`) }, 1000)')); 

  dom.window.document.head.appendChild(base)
  dom.window.document.body.appendChild(script)

  const newa = jQuery(`table.table tr:nth-child(${a}) td:nth-child(3)`).html().toString()
  const newb = jQuery(`table.table tr:nth-child(${b}) td:nth-child(3)`).html().toString()

  jQuery(`table.table tr:nth-child(${a}) td:nth-child(3)`).html(newb)
  jQuery(`table.table tr:nth-child(${b}) td:nth-child(3)`).html(newa)
  return dom
})
.then(dom => dom.serialize())
.then(html =>  s3.putObject({Body: html}).promise())

api.get('/{a}/{b}', function (request) {
  return handler(request.pathParams.a,request.pathParams.b)
});

module.exports = api;
