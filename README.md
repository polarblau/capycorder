## CAPYCORDER

Capycorder helps to record user interactions, generates simple Capybara
request specs (Rspec) and copies them into the clipboard for usage in
specs. Read more over at [polarblau.com](http://polarblau.com/2012/06/04/capycorder-beta-released.html).

### A word about TDD & BDD

Some will likely feel that this helper and what it does goes against the "tests first"
philosophy and may support bad habbits.

Test driven development is great and should definitely be prefered
over adding tests after the fact. But we all know, that sometimes
testing just doesn't happen at all or that projects come with a
few unit tests only.

I'm hoping that in this case, a small tool like *Capycorder* could
lower the barrier and aid in learning the Capybara API as well as to get
some specs running a tad faster.

### Usage

Navigate to and set-up the page you want to test as needed.

1. Activate the extension via the icon next to the browser bar
2. Enter a description for your test (optional) -- this input will be
   used for the `it 'should do something…`do … end` block.
3. Click the Capycorder icon again to enable the actions recorder.
4. Interact with your page, fill in forms, click links etc. the
   extension will create form scopes automatically where possible.
5. Click the icon a third time to switch to the matchers recorder.
6. Use the highlighter to select a DOM element or select a text range
   which should be existing within the page as a result.
7. Click the icon a last time to stop the recorder, generate the specs
   and copy everything to your clipboard.

Done, now you can use the generated specs e.g. in your Rails project.

### What's next?

As mentioned, I've build this tool for myself, so there's no roadmap.
A few things I would like to do:

* Settings panel
* Support for the syntax of other text frame works than Rspec
* Improve, refactor and test a few internals more thoroughly
* Release jquery.get_selector separately once stable
* Deal with iframes
* …

### Want to help?

By all means, any help is highly appreciated.

* The project is written in [Coffeescript](http://coffeescript.org/), please respect that
* Add specs for your changes
* Create a feature branch
* Send push request

### Contributors

* Josef Šimánek ([simi](https://github.com/simi))

### Build

The included build script will copy all files listed in the manifest
(incl. dependencies) to `/build` by default or any other DESTINATION
defined. It will also first compile all coffescript files and finally
create a .zip package ready to use.

```bash
thor build [DESTINATION]
```

You can install the ruby dependencies using bundler.

Check the [changelog](https://github.com/polarblau/capycorder/blob/master/CHANGELOG.md) for latest updates.

### Specs

Since the specs are loading fixtures via AJAX, you should run them off a
server to avoid cross-origin issues. I prefer to use
[serve](http://get-serve.com).

The specs are written using [Jasmine](http://pivotal.github.com/jasmine/) -- you can find the [docs here](http://pivotal.github.com/jasmine/jsdoc/).
