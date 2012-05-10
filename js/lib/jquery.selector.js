/*
	jQuery-GetPath v0.01, by Dave Cardwell. (2007-04-27)

	http://davecardwell.co.uk/javascript/jquery/plugins/jquery-getpath/

	Copyright (c)2007 Dave Cardwell. All rights reserved.
	Released under the MIT License.

*/

jQuery.fn.extend({
	getSelector: function(path) {
		// The first time this function is called, path won't be defined.
		if (typeof path == 'undefined') path = '';

		// If this element is <html> we've reached the end of the path.
		if (this.is('html'))
			return 'html' + path;

		// Add the element name.
    console.log(this);
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


/*
 function getXPath(node, path) {
    path = path || [];
    if(node.parentNode) {
      path = getXPath(node.parentNode, path);
    }

    if(node.previousSibling) {
      var count = 1;
      var sibling = node.previousSibling
      do {
        if(sibling.nodeType == 1 && sibling.nodeName == node.nodeName) {count++;}
        sibling = sibling.previousSibling;
      } while(sibling);
      if(count == 1) {count = null;}
    } else if(node.nextSibling) {
      var sibling = node.nextSibling;
      do {
        if(sibling.nodeType == 1 && sibling.nodeName == node.nodeName) {
          var count = 1;
          sibling = null;
        } else {
          var count = null;
          sibling = sibling.previousSibling;
        }
      } while(sibling);
    }

    if(node.nodeType == 1) {
      path.push(node.nodeName.toLowerCase() + (node.id ? "[@id='"+node.id+"']" : count > 0 ? "["+count+"]" : ''));
    }
    return path;
  };
  */
