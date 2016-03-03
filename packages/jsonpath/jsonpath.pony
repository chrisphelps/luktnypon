use "assert"
use "collections"
use "json"

type JT is (F64 | I64 | Bool | None | String | JsonArray box | JsonObject box)

class JsonPath
  let path: Array[(String | U64)]

  new create() =>
    path = Array[(String | U64)]

  fun ref obj(s: String): JsonPath ref =>
    path.push(s)
    this

  fun ref arr(i: U64): JsonPath ref =>
    path.push(i)
    this

  fun _node(jd: JsonDoc box): JT ? =>
    var jt = jd.data
    for e in path.values() do
      match e
      | let k: String =>
        let jo = jt as JsonObject box
        jt = jo.data(k)
      | let i: U64 =>
        let ja = jt as JsonArray box
        jt = ja.data(i)
      end
    end
    jt

  fun float(jd: JsonDoc box): F64 ? =>
    var jt = _node(jd)
    jt as F64

  fun int(jd: JsonDoc box): I64 ? =>
    var jt = _node(jd)
    jt as I64

  fun bool(jd: JsonDoc box): Bool ? =>
    var jt = _node(jd)
    jt as Bool

  fun string(jd: JsonDoc box): String ? =>
    var jt = _node(jd)
    jt as String

actor Main
    new create(env: Env) =>
      let gifyStr = """
{
  "data": {
    "slug": "sad-crying-alone-45cq3Gn0GH7k4",
    "rating": "y",
    "bitly_url": "http://gph.is/1cK14ir",
    "import_datetime": "2014-01-02 10:10:29",
    "source_tld": "welcometo1dandmileyhouse.tumblr.com",
    "embed_url": "https://giphy.com/embed/45cq3Gn0GH7k4",
    "type": "gif",
    "id": "45cq3Gn0GH7k4",
    "url": "https://giphy.com/gifs/sad-crying-alone-45cq3Gn0GH7k4",
    "images": {
      "downsized_medium": {
        "width": "355",
        "size": "246429",
        "height": "211",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/giphy.gif"
      },
      "fixed_height_still": {
        "width": "336",
        "height": "200",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200_s.gif"
      },
      "fixed_width_small": {
        "width": "100",
        "webp": "https://media2.giphy.com/media/45cq3Gn0GH7k4/100w.webp",
        "webp_size": "9860",
        "mp4_size": "20208",
        "size": "25815",
        "height": "59",
        "mp4": "https://media2.giphy.com/media/45cq3Gn0GH7k4/100w.mp4",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/100w.gif"
      },
      "fixed_height_small": {
        "width": "168",
        "webp": "https://media2.giphy.com/media/45cq3Gn0GH7k4/100.webp",
        "webp_size": "22486",
        "mp4_size": "41209",
        "size": "65701",
        "height": "100",
        "mp4": "https://media2.giphy.com/media/45cq3Gn0GH7k4/100.mp4",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/100.gif"
      },
      "fixed_width_downsampled": {
        "width": "200",
        "size": "91862",
        "webp": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200w_d.webp",
        "webp_size": "29386",
        "height": "119",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200w_d.gif"
      },
      "original_still": {
        "width": "355",
        "height": "211",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/giphy_s.gif"
      },
      "fixed_width_small_still": {
        "width": "100",
        "height": "59",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/100w_s.gif"
      },
      "fixed_width": {
        "width": "200",
        "webp": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200w.webp",
        "webp_size": "29386",
        "mp4_size": "8257",
        "size": "25815",
        "height": "119",
        "mp4": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200w.mp4",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200w.gif"
      },
      "fixed_height_small_still": {
        "width": "168",
        "height": "100",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/100_s.gif"
      },
      "fixed_height_downsampled": {
        "width": "336",
        "size": "226906",
        "webp": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200_d.webp",
        "webp_size": "62080",
        "height": "200",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200_d.gif"
      },
      "downsized_large": {
        "width": "355",
        "size": "246429",
        "height": "211",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/giphy.gif"
      },
      "looping": {
        "mp4": "https://media.giphy.com/media/45cq3Gn0GH7k4/giphy-loop.mp4"
      },
      "fixed_width_still": {
        "width": "200",
        "height": "119",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200w_s.gif"
      },
      "original": {
        "width": "355",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/giphy.gif",
        "webp": "https://media2.giphy.com/media/45cq3Gn0GH7k4/giphy.webp",
        "mp4_size": "28720",
        "webp_size": "66160",
        "size": "246429",
        "height": "211",
        "mp4": "https://media2.giphy.com/media/45cq3Gn0GH7k4/giphy.mp4",
        "frames": "5"
      },
      "downsized": {
        "width": "355",
        "size": "246429",
        "height": "211",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/giphy.gif"
      },
      "fixed_height": {
        "width": "336",
        "webp": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200.webp",
        "webp_size": "62080",
        "mp4_size": "7277",
        "size": "65701",
        "height": "200",
        "mp4": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200.mp4",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/200.gif"
      },
      "downsized_still": {
        "width": "355",
        "height": "211",
        "url": "https://media2.giphy.com/media/45cq3Gn0GH7k4/giphy_s.gif"
      }
    },
    "username": "",
    "source": "http://welcometo1dandmileyhouse.tumblr.com/post/71038654765/kocham-ci",
    "source_post_url": "http://welcometo1dandmileyhouse.tumblr.com/post/71038654765/kocham-ci",
    "bitly_gif_url": "http://gph.is/1cK14ir",
    "content_url": "",
    "trending_datetime": "1970-01-01 00:00:00"
  },
  "meta": {
    "msg": "OK",
    "status": 200
  }
}
      """
      try
        let jd = recover ref JsonDoc end
        try jd.parse(gifyStr) end
        let jp1 = JsonPath.obj("data").obj("embed_url")
        let eu = jp1.string(jd)
        env.out.print(eu)
        let jp2 = JsonPath.obj("meta").obj("status")
        let ms = jp2.int(jd)
        env.out.print(ms.string())
      end

