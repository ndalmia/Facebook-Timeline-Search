
function getURLParameter(name) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
}

 var highlightTermsIn = function(jQueryElements, terms) {
     var wrapper = ">$1<b style='font-weight:normal;color:#000;background-color:#aba1ab'>$2</b>$3<";
     for (var i = 0; i < terms.length; i++) {
         var regex = new RegExp(">([^<]*)?("+terms[i]+")([^>]*)?<","ig");
         jQueryElements.each(function(i) {
             $(this).html($(this).html().replace(regex, wrapper));
         }); 
     };
 }
  
 // returns array of unique search terms (words, phrases) found in value        
 var parseSearchTerms = function(value) {
     
     // split string on spaces and respect double quoted phrases
     var splitRegex = /(\u0022[^\u0022]*\u0022)|([^\u0022\s]+(\s|$))/g;
     var rawTerms = value.match(splitRegex);
     
     var terms = [];            
     for (var i = 0; i < rawTerms.length; i++) {
         
         // trim whitespace, quotes, apostrophes and query syntax special chars
         var term = rawTerms[i].replace(/^[\s\u0022\u0027+-][\s\u0022\u0027+-]*/, '').replace(/[\s*~\u0022\u0027][\s*~\u0022\u0027]*$/, '').toLowerCase();
         
         // ignore if <= 2 chars
         if (term.length <= 2) {
             continue;
         }
         
         // ignore stopwords
         var stopwords = ["about","are","from","how","that","the","this","was","what","when","where","who","will","with","the"];
         var isStopword = false;
         for (var j = 0; j < stopwords.length; j++) {
             if (term == stopwords[j]) {
                 isStopword = true;
                 break;
             }
         }
         if (isStopword === true) {
             continue;
         }
         
         // add term to term list
         terms[terms.length] = term;
     }
     return terms;
 }
