module.exports = (user)->
  languages = {}
  favoriteLanguage = ''
  favoriteLanguageCount = 0

  for comment in user.commentsLeft
    if languages[comment.language]?
      languages[comment.language]++
    else
      languages[comment.language] = 1

  for language, count of languages
    if count > favoriteLanguageCount
      favoriteLanguageCount = count
      favoriteLanguage = language

  favoriteLanguage			: favoriteLanguage
  favoriteLanguageCount : favoriteLanguageCount
