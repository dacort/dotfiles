module.exports = {
    defaultBrowser: "Google Chrome",
    handlers: [
        {
            // ~Brave~ Firefox is my Metabae browser
            match: finicky.matchHostnames(["metabase.zendesk.com", "hire.lever.co", "docs.google.com"]),
            browser: "Firefox"
        },
        {
            // Open any Metabase GitHub url in Metabae browser
            match: /github.com\/metabase/,
            browser: "Firefox"
        }
    ]
}