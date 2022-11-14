import app from './app/app'

if (!process.env.PORT) {
    throw new Error("Environment variable PORT not specified")
}

const PORT = process.env.PORT

const main = async () => {
    app.listen(PORT, () => {
        console.log(`Video Streaming service on port ${PORT}`)
    })
}

main().catch(err => {
    console.error("Microservice failed to start")
    console.error(err && err.stack || err)
})
