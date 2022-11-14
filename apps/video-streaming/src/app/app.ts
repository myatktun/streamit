import express from "express"
import { request } from 'http'

const app = express()

const VIDEO_STORAGE_HOST = process.env.VIDEO_STORAGE_HOST
const VIDEO_STORAGE_PORT = process.env.VIDEO_STORAGE_PORT

app.use(express.json())

app.get('/video', (req, res) => {
    const forwardRequest = request(
        {
            host: VIDEO_STORAGE_HOST,
            port: VIDEO_STORAGE_PORT,
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

export default app
