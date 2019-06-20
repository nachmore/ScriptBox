Dim cmd

Set args = WScript.Arguments.Unnamed
For i = args.count - 1 to 0 Step -1

  cmd = """" & args.item(i) & """ " & cmd
Next

CreateObject("Wscript.Shell").Run cmd, 0, True

