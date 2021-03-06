# milk

## configuration

### changelog

## example

```yml
# chocomilk vars

# Package Changelog
changelog: 'https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html'

# Regex for Version
versions_prefix: '20'
version: "{{ register_changelog.content |
  regex_search('DC.*\\([0-9.]+\\)') |
  regex_search('\\d+.\\d+.\\d+\\b')
  }}"

# Download URL
url: "http://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/{{ version |  regex_replace('\\.', '') }}/AcroRdrDCUpd{{ version | regex_replace('\\.', '') }}_MUI.msp"

searchreplace:
  'tools/chocolateyinstall.ps1':
    - regwxp: (^\s*[$]*MUImspURL\s*=\s*)('.*')
      replace: "$MUImspURL = '{{ url }}'"
    - regwxp: (^\s*[$]*MUImspChecksum\s*=\s*)('.*')
      replace: "$MUImspChecksum = '{{ file_hash }}'"
    - regwxp: (^\s*[$]*checksumPackage64\s*=\s*)('.*')
      replace: '$checksumPackage64 = "{{ file64_hash  | default() }}"'

# readme to description
readme:
  start: 7
  end: 48

# deploy
deploy:
  - provider: chocolatey
    repository: 'https://push.chocolatey.org/'
    key: "{{ lookup('env','CHOCOLATEY_ORG_API_KEY') }}"
  - provider: github
    name: 'itigo-bot'
    email: 'chocomilk@itigo.ch'
    url: github.com/itigoag/chocolatey.adobe-acrobat-reader-dc.git
    key: "{{ lookup('env','GITHUB_API_KEY') }}"

# Notification
notifications:
  - provider: mattermost
    url: 'https://matters.example.com'
    key: "{{ lookup('env','MATTERMOST_API_KEY') }}"
    channel: 'software-packages'
```
