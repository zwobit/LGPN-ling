xquery version "3.0";

declare namespace TEI = "http://www.tei-c.org/ns/1.0";

import module namespace config="http://www.existsolutions.com/apps/lgpn/config" at "config.xqm";
import module namespace console="http://exist-db.org/xquery/console" at "java:org.exist.console.xquery.ConsoleModule";

(: returns non-TEI structure combining morphemes & their meanings for the purposes of editing both at once,
 :  gets separated and turned into proper TEI on save :)

let $id := request:get-parameter('id', '')
 
(: let $id := 'blah':)
let $entry := collection($config:taxonomies-root)//TEI:taxonomy[@xml:id="morphemes"]/TEI:category[@baseForm=$id][1]
let $m := tokenize($entry/@ana, '\s*#')
let $c := console:log('meaninags @ana' || $entry/@ana/string())
let $c := console:log('meaninags' || string-join($m, ' '))

return    
<category xmlns="http://www.tei-c.org/ns/1.0" baseForm="{$id}">
    {
    for $meaning in collection($config:taxonomies-root)//TEI:taxonomy[@xml:id="ontology"]/TEI:category[@xml:id=tokenize($entry/@ana, '\s*#')]
        return
            <meaning label="{$meaning/@xml:id/string()}">
                <translation xml:lang="fr">{$meaning/TEI:catDesc[@xml:lang="fr"]/string()}</translation>
                <translation xml:lang="en">{$meaning/TEI:catDesc[@xml:lang="en"]/string()}</translation>
            </meaning>
    }
</category>