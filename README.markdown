# Development notes

## REST Blocks requests using Curl

**Get** all public Blocks:

    curl -H "Accept: text/xml" http://0.0.0.0:3000/blocks

**Get** a single public Block along with it's latest snippet revision:

    curl -H "Accept: text/xml" -X GET http://0.0.0.0:3000/blocks/1

or just:

    curl -H "Accept: text/xml" http://0.0.0.0:3000/blocks/1

**Destroy** a Block, regardless:

    curl -X DELETE http://0.0.0.0:3000/blocks/1

**Create** a Block posting a XML request:

    curl -H "Accept: text/xml" -H "Content-type: application/xml" -d "<block><language-id>1</language-id><is-private>f</is-private><revisions-attributes><revision><snippet>some</snippet></revision></revisions-attributes></block>" http://0.0.0.0:3000/blocks

Note Blocks don't get edited via REST, just it's revisions.

## Fixtures

Populate the Language table from fixtures using:

    rake db:fixtures:load FIXTURES=languages.yml

# Objective

Design a http://www.pastie.org clone (with some different features). We'll call the items "blocks" instead of pasties.

I do not expect to see perfect Ruby code since I know you are giving
your first steps with it. What I want to see is how you handle
yourself, how you think and how fast you can learn.

# Specifications:

* No sign up. Any visitor should be able to use the site.
* Home page should be a paginated list of public blocks.
* To create a block one should only enter its contents, language type and whether it is private or public.
* Anyone should be able to create, edit or delete a block through the site (browser) or through HTTP calls (so that it can be integrated with other applications).
* Only a block owner can edit or remove a block.
* Every time a block is edited, a new "revision" is generated. Any revision of a block can be returned (if no revision is specified, then the last revision is returned).

# Requirements:

* Log with decisions taken
* Specs/tests
