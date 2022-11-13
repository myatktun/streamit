import express from 'express'
import { request } from 'http'

if (!process.env.PORT) {
    throw new Error("Environment variable PORT not specified")
}
const app = express()

const PORT = process.env.PORT

app.get('/video', (req, res) => {
    const forwardRequest = request(
        {
            host: 'localhost',
            port: 4001,
            path: '/video?path=SampleVideo_1280x720_1mb.mp4',
            method: 'GET',
            headers: req.headers
        },
        forwardResponse => {
            res.writeHead(<number>forwardResponse.statusCode, forwardResponse.headers)
            forwardResponse.pipe(res)
        }
    )
    req.pipe(forwardRequest)
})

app.listen(PORT, () => {
    console.log(`Example app listening on port ${PORT}`)
})
