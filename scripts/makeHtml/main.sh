#!/bin/bash

function chipi.html() {
    # Create main directory if not exists
    mkdir -p static/css static/js

    # Create HTML file
    cat <<EOF >index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="./static/css/style.css">
</head>
<body>
    <script src="./static/js/script.js"></script>
</body>
</html>
EOF

    echo "" > static/css/style.css

    echo "" > static/js/script.js

    echo "Done OwO"
}

