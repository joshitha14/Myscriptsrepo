﻿'msgbox "Hi add"
'<=====  Main Program Begins Here =====>
'The PS screen identifier - similar to AppPlan identifier
scrName = "HR ImageNow*"  '###Change as needed!!
h = FindWindow(scrName)  '###Change as needed!!
if h = 0 then msgbox scrName & vbCrLf & "Window not found"
treeChunks = AppGetTree(h, "", treeNodes)

for c = 0 to treeChunks - 1
   tree = tree + treeNodes(c)
next

'###Comment out below for actual running. Use for development to see file of tree nodes
debOut(tree)

'Split the nodes into discreet lines
nodes = Split(tree, vbCrLf)

'Search the nodes for our screen's anchor and then set index values based on how far up or down from anchor
'### Search values
valEmplID = "Not Found"
valName = "Not Found"
valSSN = "Not Found"

'### Search conditions. Find anchor then set index values
'If values are towards the bottom, like a TU mod page, faster to go ln=UBound(nodes) to 1 Step -1 and reverse order of searches for anchors
for ln = 100 to UBound(nodes)  'top of page down
  'Look for anchor and then set values based on offset from there. MUST include brackets [] since the words might appear multiple times on screen
  if (Instr(nodes(ln), "[Empl ID:]") > 0) then 
    'using offset approach
    valEmplID = GetName(nodes(ln + 2)) & GetName(nodes(ln + 3)) & GetName(nodes(ln + 4))
  end if
  if (Instr(nodes(ln), "[Display Name:]") > 0) then 
    'using offset approach
    valName = GetName(nodes(ln + 2)) & GetName(nodes(ln + 3)) & GetName(nodes(ln + 4))
  end if
  if (Instr(nodes(ln), "label[National ID:]") > 0) then 
    'using offset approach
    valSSN = Right(GetName(nodes(ln + 2)) & GetName(nodes(ln + 3)) & GetName(nodes(ln + 4))),4)
   Exit For  'last anchor
  end if
next  'ln

'###These MUST match the AppPlan dictionary
field("TU ID") = valEmplID
field("Name") = valName
field("SSN") = valSSN

'***Functions used in script***
' return text between [] which represents name field
function GetName(text)
  if InStr(text, "[") > 0 and InStr(text, "]") > 0 then
    GetName = Mid(text, InStr(text, "[")+1, InStr(text,"]")-InStr(text, "[")-1)
  end if
end function

' write tree to text file
function debOut(tree)
  'fn = "O:\Information Systems\ImageNow\AppGetData\debout.txt"  'IN folder
  fn = "C:\Users\" + CreateObject("WScript.Network").UserName + "\Downloads\PS_Screen.txt"  'user's folder
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  Set objFile = objFSO.CreateTextFile(fn, True, true)
  objFile.Write(tree)
  objFile.Close
  'CreateObject("WScript.Shell").Run(fn)
end function
