import app from './app/app'

if (!process.env.PORT) {
    throw new Error("Environment variable PORT not set")
}

const PORT = process.env.PORT

app.listen(PORT, () => {
    console.log(`AWS Storage service on port ${PORT}`)
})
