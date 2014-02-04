<?php
// Get the domain query parameter, use example.com if we don't have one.
if (!isset($_REQUEST['url']))
    $domain = 'www.example.com';
else {
    // Since the decisions are made only on the domain, let's *just* show the domain.
    preg_match('#[a-z]+://([^/]+)/#i', str_rot13($_REQUEST['url']), $domain);
    $domain = $domain[1];
}

// Set a default type to "block".  This allows us to just referance the block page
// and see an example of what it would look like without needing extra parameters
if (!isset($_REQUEST['type']))
    $_REQUEST['type'] = 'block';

// Show the appropriate messaging based on the redirect type
switch ($_REQUEST['type']) {
    // Blocked Categories/Domains
    case 'block':
    case 'ablock':
        $message = 'was blocked on this network.';
        if (isset($_REQUEST['cats'])) {
            // categories are an escaped JSON array
            $message .= '<br />Blocked Categories: ' . implode(", ", json_decode(stripslashes($_REQUEST['cats'])));
        }
    break;
    
    // Phishing Domains
    case 'phish':
        $message = 'is believed to be involved in a phishing attack.';
    break;
    
    // Typo Correction / SERVFAIL / NXDOMAIN
    case 'nav':
        // Do we have a typo correction?
        if (isset($_REQUEST['spell'])) {
            // if we have a spelling correction, you can simply redirect the user there
            header("Location: {$_REQUEST['spell']}");
            exit;
        }
        else {
            $message = 'is not a valid domain or is not working at this time.';
        }
    break;
    
    default:
        // You should probably log anything like this as it means people are either
        // playing with your block page or OpenDNS added an additional type and you
        // should be checking the documentation to see what it means.
        $message = "is {$_REQUEST['type']}";
    break;
}
?>
<html>
<head>
<title>Sample PHP Block Page</title>
</head>
<body>
<!-- I'm not very stylistic, so this is a very plain block page.  Please feel  -->
<!-- free to do something a little nicer!                                      -->
<?php echo $domain, " ", $message; ?>
</body>
</html>