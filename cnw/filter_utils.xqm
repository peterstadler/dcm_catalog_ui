xquery version "1.0" encoding "UTF-8";

module  namespace filter="http://kb.dk/this/app/filter";

import module namespace  forms="http://kb.dk/this/formutils" at "./form_utils.xqm";

declare namespace m="http://www.music-encoding.org/ns/mei";
declare variable $filter:anthologies := request:get-parameter("anthologies","yes") cast as xs:string;
declare variable $filter:sortby := request:get-parameter("sortby", "null,work_number") cast as xs:string;
declare variable $filter:page   := request:get-parameter("page",   "1") cast as xs:integer;
declare variable $filter:number := request:get-parameter("itemsPerPage","20") cast as xs:integer;
declare variable $filter:genre := request:get-parameter("genre", "") cast as xs:string;
declare variable $filter:uri    := "";
declare variable $filter:vocabulary := doc("./keywords.xml");

declare variable $filter:anthology-options := 
(<option value="no">Include anthologies</option>,
<option value="yes">Exclude anthologies</option>);




declare function filter:print-filters(
  $database        as xs:string,
  $published_only  as xs:string,
  $coll            as xs:string,
  $number          as xs:string,
  $genre           as xs:string,
  $query           as xs:string) 
{
  let $notafter  := request:get-parameter("notafter","1931")
  let $notbefore := request:get-parameter("notbefore","1880")

  let $filter:=
      <form action="navigation.xq" method="get" class="search" id="query_form" name="query_form">
      <div class="filter_block">
        <input name="itemsPerPage"  value='{$number}' type='hidden' />
        <input name="sortby"  value='{$filter:sortby}' type='hidden' />
        <!--
        <span class="label input_label">Title</span>
        <input name="title" class="query_input" value='{request:get-parameter("title","")}' id="title_input"/>
        <a class="help">?<span class="comment"> 
        Search terms may be combined using boolean operators. Wildcards allowed. 
        Search is case insensitive (except for boolean operators, which must be uppercase).
        Some examples:<br/>
        <span class="help_table">
          <span class="help_example">
            <span class="help_label">carl OR nielsen</span>
            <span class="help_value">Boolean OR (default)</span>
          </span>                        
          <span class="help_example">
            <span class="help_label">carl AND nielsen</span>
            <span class="help_value">Boolean AND</span>
          </span>
          <span class="help_example">
            <span class="help_label">"carl nielsen"</span>
            <span class="help_value">Exact phrase</span>
          </span>
          <span class="help_example">
            <span class="help_label">niels*</span>
            <span class="help_value">Match any number of characters. Finds Niels, Nielsen and Nielsson<br/>
            (use only at end of word)
            </span>
          </span>
          <span class="help_example">
            <span class="help_label">niels?n</span>
            <span class="help_value">Match 1 character. Finds Nielsen and Nielson, but not Nielsson</span>
          </span>
        </span>
      </span>
      </a>-->
      </div>
      
      <div class="filter_block">
        <span class="label input_label">Keywords</span>
        <input name="query" class="query_input" value='{request:get-parameter("query","")}' id="query_input"/>
      </div>
      <div class="filter_block">
	<span class="label">Year of composition</span>    
	<table cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td style="padding-left: 0;">
            <input id="notbefore" name="notbefore" value="{$notbefore}" onblur="setYearSlider()"/>
            </td>
            <td>
	      <div class="slider" id="year_slider">
		{" "}
	      </div>
            </td>
            <td>
	      <input id="notafter" 
	      name="notafter" 
	      value="{$notafter}" 
	      onblur="setYearSlider()"/>
            </td>
          </tr>
	</table>
	</div>

      <div class="genre_filter filter_block">
	{
	  for $genre in $filter:vocabulary/m:classification/m:termList[@label="level1" or @label="level2"]/m:term/string()
	    let $selected :=
          if ($genre=$filter:genre) then "selected" else ""

 	return 
	  if ($filter:vocabulary/m:classification/m:termList[m:term/string()=$genre]/@label="level2")
	    then 
	    (  
	    <label for="{concat('id',translate($genre,' ',''))}" class="genre_filter_row level2 {$selected}">
	      { element input {
	            attribute type {"radio"},
                attribute name {"genre"},
                attribute value {$genre},
                attribute id {concat("id",translate($genre," ",""))},
                attribute class {"radio"},
	       if($selected="selected") then
	           attribute checked {"checked"}
	       else
	           ()
           }
	      }
          <span class="genre_indicator {translate(translate($genre,' ,','_'),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')}">&#160;</span> &#160; {$genre} 
	    </label> 
	    )
          else
          <label for="{concat('id',translate($genre,' ',''))}" class="genre_filter_row level1 {$selected}">
	      { element input {
	            attribute type {"radio"},
                attribute name {"genre"},
                attribute value {$genre},
                attribute id {concat("id",translate($genre," ",""))},
                attribute class {"checkbox"},
	       if($selected="selected") then
	           attribute checked {"checked"}
	       else
	           ()
           }
	      }
	      <span class="genre_indicator">&#160;</span>
	    {$genre} 
          </label>
        }
         </div>
         
      <div class="filter_block">
        {     
            element input {
    	    attribute type {"checkbox"},
            attribute name {"anthologies"},
            attribute value {"yes"},
            attribute class {"checkbox"},
	        if($forms:anthologies="yes") then
	           attribute checked {"checked"}
	        else
	           ()
	        }
        } Exclude song collections
         </div>
         
	      <div class="filter_block">
            <input type="submit" value="Search" class="search_submit" id="search_submit"/>
          </div>
        </form>

    return $filter
};


declare function filter:count-hits(
  $term as xs:string,
  $list as node()*) as xs:integer* 
{
  let $number :=
  for $count in count($list//m:workDesc[contains(m:work/m:classification/m:termList/m:term/string(),$term) ])
    return $count
  return $number
};

declare function filter:filter-elements() 
{
  let $notafter  := request:get-parameter("notafter","")
  let $notbefore := request:get-parameter("notbefore","")
  let $query := request:get-parameter("query","")
  let $title := request:get-parameter("title","")
  let $genre := request:get-parameter("genre","")
  let $anthologies := request:get-parameter("anthologies","")
  let $this_uri := fn:concat($filter:uri,"?",request:get-query-string())
 
  let $year_block :=
      if(($notbefore and $notbefore!="1880") or ($notafter and $notafter!="1931")) then
       <a class="filter_element"
           href="{fn:replace(fn:replace($this_uri,'notbefore=\d*','notbefore='),'notafter=\d*','notafter=')}">
           Year of composition: {$notbefore}–{$notafter} 
       </a>
    else
       ""
  let $title_block :=
      if($title) then
       <a class="filter_element"
           href="{fn:replace($this_uri,'title=[^&amp;]+','title=')}">
           Title: {$title} 
       </a>
    else
       ""
  let $query_block :=
      if($query) then
       <a class="filter_element"
           href="{fn:replace($this_uri,'query=[^&amp;]+','query=')}">
           Keyword(s): {$query} 
       </a>
    else
       ""
  let $genre_block :=
      if($genre) then
       <a class="filter_element" 
           href="{fn:replace($this_uri,'genre=[^&amp;]+','genre=')}">
           Genre: {$genre} 
       </a>
    else
       ""
  let $anthology_block :=
      if($anthologies) then
       <a class="filter_element" 
           href="{fn:replace($this_uri,'anthologies=[^&amp;]+','anthologies=')}">
           Exclude song collections 
       </a>
    else
       ""
  let $reset_block :=
      if($genre_block or $year_block or $query_block or $anthology_block or $title_block) then
       <a class="filter_element reset" 
           href="{fn:concat($filter:uri,'?itemsPerPage=',request:get-parameter("itemsPerPage",""),'&amp;sortby=',request:get-parameter("sortby",$filter:sortby))}">
           Reset all
       </a> 
    else
       ""
  let $clear :=
      <br style="clear:both"/>
  return ($title_block, $query_block, $year_block, $genre_block, $anthology_block, $reset_block, $clear)
};



declare function filter:print-filtered-link(
  $database        as xs:string,
  $published_only  as xs:string,
  $coll            as xs:string,
  $number          as xs:string,
  $query           as xs:string,
  $term            as xs:string) as node()*
{
  let $link := (
    element a 
    {
      attribute title {"Filter with ",$term},
      attribute href {
	concat($filter:uri,"?",
	  "page=",1,
	  "&amp;itemsPerPage=",$number,
	  "&amp;sortby=",request:get-parameter("sortby",$filter:sortby),
	  "&amp;c=",$coll,
	  "&amp;published_only=",$published_only,
	  "&amp;query=",$query,
	  "&amp;anthologies=",$filter:anthologies,
	  "&amp;notbefore=",request:get-parameter("notbefore",""),
	  "&amp;notafter=",request:get-parameter("notafter",""),
	  "&amp;genre=",fn:escape-uri($term,true()))},
	  $term
    }
    )
    return $link
};

declare function filter:get-filtered-link(
  $coll            as xs:string,
  $number          as xs:string,
  $query           as xs:string,
  $term            as xs:string) as xs:string
{
  let $link := 
	concat($filter:uri,"?",
	  "page=",1,
	  "&amp;itemsPerPage=",$number,
	  "&amp;sortby=",request:get-parameter("sortby",$filter:sortby),
	  "&amp;c=",$coll,
	  "&amp;query=",$query,
	  "&amp;anthologies=",$filter:anthologies,
	  "&amp;notbefore=",request:get-parameter("notbefore",""),
	  "&amp;notafter=",request:get-parameter("notafter",""),
	  "&amp;genre=",fn:escape-uri($term,true()))
    return $link
};

