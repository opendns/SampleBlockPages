<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Sample ASPX Block Page in C#</title>
</head>
<script runat="server">
// Make sure you have references to the following:
//using System.Text.RegularExpressions;
//using System.Web.Extensions;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Get the domain query parameter, use example.com if we don't have one.
        if (Request.QueryString["url"] != null)
        {
            // Since only the domain (no http) is returned from the landers, this is the domain label to print
             DomainLabel.Text = Rot13.Transform(Request.QueryString["url"]);
             

        }
        else
        {
            DomainLabel.Text = "www.example.com";
        }
        
        // Set a default type to "block".  This allows us to just referance the block page
        // and see an example of what it would look like without needing extra parameters
        string type = Request.QueryString["type"];
        if (type == null)
        {
            type = "block";
        }
        
        // Show the appropriate messaging based on the redirect type
        switch (type)
        {
            // Blocked Categories/Domains
            case "ablock": goto case "block";
            case "block":
                MessageLabel.Text = "was blocked on this network";
                if (Request.QueryString["cats"] != null)
                {
                    // categories are an escaped JSON array
                    System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                    string[] categories = serializer.Deserialize<string[]>(Request.QueryString["cats"]);
                    MessageLabel.Text += "<br /> Blocked Categories: " + String.Join(", ", categories);
                }
                break;

            // Phishing Domains
            case "phish":
                MessageLabel.Text = "is believed to be involved in a phishing attack";
                break;

            default:
                // You should probably log anything like this as it means people are either
                // playing with your block page or OpenDNS added an additional type and you
                // should be checking the documentation to see what it means.
                MessageLabel.Text = "is " + type;
                break;
        }
    }

    // This code is from http://dotnetperls.com/rot13
    static class Rot13
    {
        /// <summary>
        /// Performs the ROT13 character rotation.
        /// </summary>
        public static string Transform(string value)
        {
            char[] array = value.ToCharArray();
            for (int i = 0; i < array.Length; i++)
            {
                int number = (int)array[i];

                if (number >= 'a' && number <= 'z')
                {
                    if (number > 'm')
                    {
                        number -= 13;
                    }
                    else
                    {
                        number += 13;
                    }
                }
                else if (number >= 'A' && number <= 'Z')
                {
                    if (number > 'M')
                    {
                        number -= 13;
                    }
                    else
                    {
                        number += 13;
                    }
                }
                array[i] = (char)number;
            }
            return new string(array);
        }
    }
</script>
<body>
<!-- I'm not very stylistic, so this is a very plain block page.  Please feel  -->
<!-- free to do something a little nicer!                                      -->
    <form id="form1" runat="server">
    <div>
    
        <asp:Label ID="DomainLabel" runat="server" Text="Label"></asp:Label>
        <asp:Label ID="MessageLabel" runat="server" Text="Label"></asp:Label>
    
    </div>
    </form>
</body>
</html>
