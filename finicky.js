// ~/.finicky.js
module.exports = {
  defaultBrowser: "Safari",
  handlers: [
    {
        // You can get the path of the process that triggered Finicky (EXPERIMENTAL)
        match: ({ opener }) =>
          opener.path && opener.path.startsWith("/Applications/Slack.app"),
          browser: "Google Chrome"
    }
  ]
};

