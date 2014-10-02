xquery version "1.0" encoding "UTF-8";

import module namespace layout="http://kb.dk/this/app/layout" at "./cnw-layout.xqm";
declare option exist:serialize "method=xml media-type=text/html;charset=UTF-8";
declare variable $mode   := request:get-parameter("mode","preface") cast as xs:string;

<html xmlns="http://www.w3.org/1999/xhtml">
  {layout:head("Preface: Carl Nielsen Works Catalogue (CNW)",(<link rel="stylesheet" type="text/css" href="/editor/style/mei_to_html_public.css"/>))}
  <body class="text">
    <div id="all">
      {layout:page-head("CNW","Carl Nielsen Works Catalogue")}
      {layout:page-menu($mode)}
      <div id="main">
      <h1>Preface</h1>
<p>The Carl Nielsen Works Catalogue (CNW) is the first ever thematic-bibliographic registration of all
Nielsen’s compositions. A few catalogues have previously been
prepared of which <a class="abbr" 
href="javascript:void(0);">Fog and Schousboe’s<span class="expan">Dan Fog and Torben Schousboe: 
<i>Carl Nielsen. Kompositioner. En Bibliografi</i>. Copenhagen 1965</span></a> bibliography (1965) was the first.
The <a class="abbr" 
href="javascript:void(0);">Bjørnum and
Møllerhøj<span 
class="expan">Birgit Bjørnum and Klaus Møllerhøj, <i>Carl Nielsens
Samling. Katalog over komponistens musikhåndskrifter i Det kongelige Bibliotek</i>. Copenhagen 1992</span></a>  
description of Nielsen’s manuscripts in The Royal Library (1992) is
one of the most important groundworks though it strictly speaking is not a work
catalogue.</p> 
 <p>The first complete survey of all Nielsen’s compositions and their sources was not initiated,
however, until the foundation of the <a href="http://www.kb.dk/en/nb/dcm/cnu/" target="_blank"
title="The Carl Nielsen Edition">The Carl Nielsen Edition</a> <a class="abbr" 
href="javascript:void(0);">(CNU; completed 2009)<span class="expan"> 
<i>Carl Nielsen Udgaven</i>. The Royal Library: Copenhagen 1998–2009</span></a>. In more than one sense, 
CNW is a natural extension of CNU and builds to a large degree on information accumulated 
in connection with the editing project and to a certain extent also in connection with other projects. 
The information has been rectified when the editors either have been aware of 
or had their attention drawn to errors. However, due to limited resources the editors 
have not been able to verify all information systematically. 
Original sources have only been consulted in cases of doubt. </p>
<p>The Danish Centre for Music
Publication which is responsible for the publication of CNW was established at The
Royal Library shortly after the completion of the Carl Nielsen Edition in order to 
maintain and carry on the music philological
expertise and not least exploit the detailed knowledge of Nielsen’s works that
had been gathered during the working on the complete edition. 
</p>
<p>Biographical as well as bibliographic information has also been drawn from a number of other
sources, among others the <a class="abbr" 
href="javascript:void(0);"><i>Carl Nielsen Letters</i><span class="expan">John Fellow (ed.), <i>Carl
Nielsen Brevudgaven</i>. Copenhagen 2005–</span></a>, the publication
of Nielsen’s other <a class="abbr" 
href="javascript:void(0);"><i>essays</i><span class="expan">John Fellow (ed.), <i>Carl
Nielsen til sin samtid</i>. Copenhagen 1999</span></a>, and the current bibliography
available in the journal, <a href="https://tidsskrift.dk/index.php/carlnielsenstudies" 
title="Carl Nielsen Studies – fulltext online" target="_blank"><i>Carl Nielsen Studies</i></a>,
all affiliated with The Royal Library. </p>
<p>We wish to express our sincerest
thanks to Carl Nielsen og Anne Marie Carl-Nielsens Legat (the Carl Nielsen 
and Anne Marie Carl-Nielsen&apos;s Foundation) for
financial support of the project. Thanks are also due to Knud Ketting
who most kindly has provided us with information on the first known
performances of the musical works.</p>
<div><br clear="all"/>

</div>
      </div>
      {layout:page-footer($mode)}
    </div>
  </body>
</html>

