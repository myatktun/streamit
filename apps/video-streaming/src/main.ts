import app from './app/app'

if (!process.env.PORT) {
    throw new Error("Environment variable PORT not specified")
}

const PORT = process.env.PORT

app.listen(PORT, () => {
    console.log(`Video Streaming service on port ${PORT}`)
})
