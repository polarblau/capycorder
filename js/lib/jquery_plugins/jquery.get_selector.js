/*
	jQuery-GetPath v0.01, by Dave Cardwell. (2007-04-27)

	http://davecardwell.co.uk/javascript/jquery/plugins/jquery-getpath/

	Copyright (c)2007 Dave Cardwell. All rights reserved.
	Released under the MIT License.

*/
// TODO: ensure as short selector as possible by
//       testing for result length for current selection in every round
jQuery.fn.extend({
	getSelector: function(path) {
		// The first time this function is called, path won't be defined.
		if (typeof path == 'undefined') path = '';

		// If this element is <html> we've reached the end of the path.
		if (this.is('html'))
			return 'html' + path;

		// Add the element name.
		var cur = this.get(0).nodeName.toLowerCase();

		// Determine the IDs and path.
		var id    = this.attr('id'),
		    klass = this.attr('class');


		// Add the #id if there is one.
		if (typeof id != 'undefined')
			cur += '#' + id;

		// Add any classes.
		if (typeof klass != 'undefined')
			cur += '.' + klass.split(/[\s\n]+/).join('.');

		// Recurse up the DOM.
		return this.parent().getSelector(' > ' + cur + path);
	}
});

