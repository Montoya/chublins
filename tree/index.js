// Hash a file
var merkle = require('merkle-tree-gen');
 
// Set up the arguments
var args = {
    file: 'allowlist.txt' // required
};
 
// Generate the tree
merkle.fromFile(args, function (err, tree) {
 
    if (!err) {
        console.log('Root hash: ' + tree.root);
        console.log('Number of leaves: ' + tree.leaves);
        console.log('Number of levels: ' + tree.levels);
    }
});