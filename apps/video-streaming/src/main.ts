import * as express from 'express'
import * as path from 'path'
import { promises, createReadStream } from 'fs'

const app = express()

const PORT = 3000

app.get('/video', async (req, res) => {
    const videoPath = path.join(__dirname, './videos/SampleVideo_1280x720_1mb.mp4')
    const stats = await promises.stat(videoPath)

    res.writeHead(200, {
        'Content-Length': stats.size,
        'Content-Type': 'video/mp4'
    })
    createReadStream(videoPath).pipe(res)
})

app.listen(PORT, () => {
    console.log(`Example app listening on port ${PORT}`)
})
