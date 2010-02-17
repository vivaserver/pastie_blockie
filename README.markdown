# Development Notes

## REST Blocks requests using Curl

Note following requests include Curl cookie handling to pass app. authentication:

**Get** all public Blocks:

    curl -H "Accept: text/xml" --cookie pastie.cookie http://0.0.0.0:3000/blocks

pagination also works:

    curl -H "Accept: text/xml" --cookie pastie.cookie http://0.0.0.0:3000/blocks?page=2

**Get** a single public Block along with it's latest snippet revision:

    curl -H "Accept: text/xml" --cookie pastie.cookie -X GET http://0.0.0.0:3000/blocks/1

or just:

    curl -H "Accept: text/xml" --cookie pastie.cookie http://0.0.0.0:3000/blocks/1

**Destroy** a Block:

    curl -H "Accept: text/xml" --cookie pastie.cookie -X DELETE http://0.0.0.0:3000/blocks/1

**Create** a Block posting a XML request (-d option implies POST):

    curl -H "Accept: text/xml" -H "Content-type: application/xml" --cookie-jar pastie.cookie -d "<block><language-id>1</language-id><is-private>true</is-private><revisions-attributes><revision><snippet>some code snippet goes here</snippet></revision></revisions-attributes></block>" http://0.0.0.0:3000/blocks

Also note that Blocks don't get edited via REST requests, just it's revisions.

## REST Blocks Revisions requests usign Curl

**Get** a particular revision, prividing the block is public:

    curl -H "Accept: text/xml" http://0.0.0.0:3000/blocks/3/revisions/9

**Edit** actually creates a new revision:

    curl -H "Accept: text/xml" -H "Content-type: application/xml" --cookie pastie.cookie -d "<revision><snippet>even more code snippet goes here</snippet></revision>" -X PUT http://0.0.0.0:3000/blocks/10/revisions/11

**Destroy** a revision, unless it's marked as private:

    curl -H "Accept: text/xml" --cookie pastie.cookie -X DELETE http://0.0.0.0:3000/blocks/5/revisions/5

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
