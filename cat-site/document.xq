xquery version "1.0" encoding "UTF-8";

import module namespace layout="http://kb.dk/this/app/layout" at "./cnw-layout.xqm";

declare namespace transform="http://exist-db.org/xquery/transform";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace response="http://exist-db.org/xquery/response";
declare namespace fn="http://www.w3.org/2005/xpath-functions";
declare namespace file="http://exist-db.org/xquery/file";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace app="http://kb.dk/this/app";
declare namespace ft="http://exist-db.org/xquery/lucene";
declare namespace m="http://www.music-encoding.org/ns/mei";

declare option exist:serialize "method=xml media-type=text/html"; 

declare variable $coll     := request:get-parameter("c","") cast as xs:string;
declare variable $document := request:get-parameter("doc", "");
declare variable $mode     := request:get-parameter("mode","") cast as xs:string;
declare variable $host     := request:get-header('HOST');
declare variable $sheet    := xs:anyURI(concat('http://',$host,"/dcm/cnw/style/transforms/mei_to_html_public.xsl"));

declare variable $database := concat("/db/cat-site/",$coll,"/data");

let $list := 
for $doc in collection($database)
where util:document-name($doc)=$document
return $doc

let $c := $list//m:fileDesc/m:seriesStmt/m:identifier[@type="file_collection"][1]/string()
let $work_number := $list//m:meiHead/m:workDesc/m:work[1]/m:identifier[@label=$c]/string()
let $title := $list//m:workDesc/m:work[1]/m:titleStmt[1]/m:title[string()][not(@type/string())][1]/string()
let $head_title := 
   fn:concat($title," – ",$c," ",$work_number," – Catalogue of Carl Nielsen&apos;s Works")

let $result :=
<html xmlns="http://www.w3.org/1999/xhtml">
  {layout:head($head_title,
	  (<link rel="stylesheet" type="text/css" href="style/mei_to_html_public.css"/>,
	  <script type="text/javascript" src="js/toggle_openness.js">{"
	  "}</script>
	  ))}
  <body class="list_files">
    <div id="all">
      {layout:page-head("CNW","Catalogue of Carl Nielsen's Works")}
      {layout:page-menu($mode)}
      <div id="main">
      {
	for $doc in $list
	let $params := 
	<parameters>
	  <param name="hostname"    value="{$host}"/>
	  <param name="script_path" value="./document.xq"/>
	  <param name="doc" value="{util:document-name($doc)}"/>
	</parameters>
	return transform:transform($doc,$sheet,$params)
      }
      </div>
      {layout:page-footer($mode)}
    </div>

  </body>

</html>
 
return $result