#!/usr/bin/env coffee

module.exports = {
selectLanguageName: "English"
navbar: [
  {
    text: 'i18n.site : MarkDown Translation & Website Building Tool',
    link: 'https://i18n.site'
  }
  {
    text: 'Chat',
    children: [
      {
        text: 'WEB',
        link: 'https://rmw.zulipchat.com'
      }
      {
        text: 'APP',
        link: 'https://rmw.zulipchat.com/apps'
      }
    ]
  }
]
}
