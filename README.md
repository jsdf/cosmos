cosmos cms
======

*postgres 9.4 json documents + reactjs ui = cms*

![mind blown](https://jamesfriend.com.au/files/mind_blown.gif)

Okay so I haven't got to far with this project yet but here are the big ideas:

## CMSes are for documents, so use a document store
Postgres 9.4 provides a JSON document column type backed by a fast binary representation, which is ideal for storing the kind of varied and structured data which CMSes tend to be used for. Typically, in the CMS use-case, document fields/attributes are often added and removed as 'content types' are built up interactively via an admin interface. By extracting the content type schema definition to a JSON schema document, we can enjoy the flexibility of interactive content type building, while also keeping the schema definitions in files which can be checked into version control. Additionally, we still have the full power of a relational database at our disposal.

## Rendering on the server or in the browser

Being able to render our content using the same components on the server (for public-facing display) and in the browser (when creating content) enables powerful real time previewing and inline editing workflows.
