xquery version "1.0" encoding "UTF-8";

import module namespace loop="http://kb.dk/this/getlist" at "./main_loop.xqm";
import module namespace app="http://kb.dk/this/listapp" at "./list_utils.xqm";
import module namespace filter="http://kb.dk/this/app/filter" at "./filter_utils.xqm";
import module namespace layout="http://kb.dk/this/app/layout" at "./cnw-layout.xqm";

declare namespace xl="http://www.w3.org/1999/xlink";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace response="http://exist-db.org/xquery/response";
declare namespace fn="http://www.w3.org/2005/xpath-functions";
declare namespace file="http://exist-db.org/xquery/file";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace ft="http://exist-db.org/xquery/lucene";
declare namespace ht="http://exist-db.org/xquery/httpclient";
declare namespace m="http://www.music-encoding.org/ns/mei";

declare namespace local="http://kb.dk/this/app";

declare option exist:serialize "method=xml media-type=text/html"; 

declare variable $genre  := request:get-parameter("genre","") cast as xs:string;
declare variable $coll   := request:get-parameter("c",    "") cast as xs:string;
declare variable $query  := request:get-parameter("query","");
declare variable $page   := request:get-parameter("page", "1") cast as xs:integer;
declare variable $number := request:get-parameter("itemsPerPage","20") cast as xs:integer;
declare variable $mode   := request:get-parameter("mode","") cast as xs:string;

declare variable $vocabulary := doc(concat("http://",request:get-header('HOST'),"/storage/cnw/keywords.xml"));

declare variable $database := "/db/cnw/data";

declare variable $from     := ($page - 1) * $number + 1;
declare variable $to       :=  $from      + $number - 1;

declare variable $published_only := "";

declare variable $sort-options :=
(<option value="null,work_number">Work number</option>,
<option value="null,title">Title</option>,
<option value="date,title">Year</option>
);



<html xmlns="http://www.w3.org/1999/xhtml">
   {layout:head("Catalogue of Carl Nielsen&apos;s Works (CNW)",(<link rel="stylesheet" type="text/css" href="/storage/style/public_list_style.css"/>))}
    <body class="list_files">
    
      <div id="all">
      {layout:page-head("CNW","Catalogue of Carl Nielsen&apos;s Works")}
      {layout:page-menu($mode)}

      <div id="main">
         <div class="content_box">
    	<div class="filter">
    	{filter:print-filters($database,$published_only,$coll,string($number),$genre,$query)}
    	</div>
    </div> 
    </div> 

    {layout:page-footer($mode)}

    </div> 

  </body>
</html>
