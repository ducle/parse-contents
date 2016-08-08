# Parse Content

The application provides 2 endpoints for parsing HTML page from url parameter, and returns stored parsed contents.

## Getting started
Clone the code, run `bundle`, `rake db:create db:migrate` and you are done.

## API details

### Parsing API: `/api/sites`
  Accepts an URL as parameter, parses the page at that URL, and stores all contents within H1, H2, H3 and hrefs found.

  Required params: `url`
  
  Example: 
```curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{"url": "https://github.com/"}' 'http://localhost:3000/api/sites'```

### Listing contents API: `/api/site_contents`
  Returns list of stored contents, paginated, with per_page=30.

  Optional params: `page`

  Example:
  ```curl -X GET --header 'Content-Type: application/json' --header 'Accept: application/json' 'http://localhost:3000/api/site_contents'```
  
## TODOS:
- Moving processing url to background job.

  


