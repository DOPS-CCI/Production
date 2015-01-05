#INCLUDE "MSXML_Local.inc"

SUB DisplayNode(BYVAL Nodes AS IXMLDOMNodeList, BYVAL Indent AS INTEGER)
   LOCAL  xNode AS IXMLDOMNode
   LOCAL i AS LONG
   LOCAL temp AS VARIANT

   Indent = Indent + 2

   FOR i = 0 TO Nodes.length - 1
       xNode = Nodes.nextNode()
      IF xNode.nodeType = %tagDOMNodeType.NODE_TEXT THEN
          #DEBUG PRINT SPACE$(Indent) + xNode.parentNode.nodeName + ":" + VARIANT$(xNode.nodeValue)
      END IF

      IF xNode.hasChildNodes THEN
         CALL DisplayNode(xNode.childNodes, Indent)
      END IF
   NEXT i
END SUB

SUB GetNode(BYVAL Nodes AS IXMLDOMNodeList, BYVAL Indent AS INTEGER, nodeName AS STRING, BYREF result AS STRING)
   LOCAL  xNode AS IXMLDOMNode
   LOCAL i AS LONG
   LOCAL temp AS VARIANT
   LOCAL temp2 AS STRING

   Indent = Indent + 2

    temp2 = MID$(nodeName, 3, 7)
    #DEBUG PRINT temp2
   FOR i = 0 TO Nodes.length - 1
       xNode = Nodes.nextNode()
      IF xNode.nodeType = %tagDOMNodeType.NODE_TEXT THEN
          #DEBUG PRINT SPACE$(Indent) + xNode.parentNode.nodeName + ":" + VARIANT$(xNode.nodeValue)

          IF (xNode.parentNode.nodeName = temp2) THEN
              #DEBUG PRINT SPACE$(Indent) + xNode.parentNode.nodeName + ":" + VARIANT$(xNode.nodeValue)
              result = VARIANT$(xNode.nodeValue)
          END IF
      END IF

      IF xNode.hasChildNodes THEN
         CALL GetNode(xNode.childNodes, Indent, nodeName, result)
      END IF
   NEXT i

END SUB

SUB UpdateNode(BYVAL Nodes AS IXMLDOMNodeList, BYVAL Indent AS INTEGER, nodeName AS STRING, nodeValue AS STRING) STATIC
   LOCAL  xNode AS IXMLDOMNode
   LOCAL i AS LONG
   LOCAL temp AS VARIANT
   LOCAL temp2 AS STRING

   Indent = Indent + 2

   temp2 = MID$(nodeName, 3, 7)
   FOR i = 0 TO Nodes.length - 1
       xNode = Nodes.nextNode()
      IF xNode.nodeType = %tagDOMNodeType.NODE_TEXT THEN
          IF (xNode.parentNode.nodeName = temp2) THEN
             #DEBUG PRINT SPACE$(Indent) + xNode.parentNode.nodeName + ":" + VARIANT$(xNode.nodeValue)
             temp = nodeValue
             xNode.nodeValue = temp
          END IF
      END IF

      IF xNode.hasChildNodes THEN
         CALL UpdateNode(xNode.childNodes, Indent, nodeName, nodeValue)
      END IF
   NEXT i
END SUB
