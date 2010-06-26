<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="mockey" uri="/WEB-INF/mockey.tld" %>
<c:set var="pageTitle" value="History" scope="request" />
<c:set var="currentTab" value="history" scope="request" />
<%@include file="/WEB-INF/common/header.jsp" %>
<script>
$(document).ready(function() {


		var makeExactlyAsTallAsItNeedsToBe = function(textArea) {
			var content = $(textArea).val() == undefined ? "" : $(textArea).val();
			var numOfRowsOfContent = 1;
			try { numOfRowsOfContent = content.match(/[^\n]*\n[^\n]*/gi).length; } catch(e) {}
			var maxSize = 40;
			textArea.rows = numOfRowsOfContent<maxSize?numOfRowsOfContent+1:maxSize;
		}
		$('textarea').each( function() {
			makeExactlyAsTallAsItNeedsToBe(this);
			$(this).keyup( function(e) {
				makeExactlyAsTallAsItNeedsToBe(this);
			});
			$(this).change( function(e) {
				makeExactlyAsTallAsItNeedsToBe(this);
			});
			$(this).bind( "reformatted", function(e) {
				makeExactlyAsTallAsItNeedsToBe(this);
			});
		});

	$('#filter-button').button();
	
	$('.mockeyResponse').each( function() {
		var formatButton = $(this).find(".formatButton")[0];
		$(formatButton).click( function() {
			var contentTextArea = $(this).parent().parent().find(".responseContent")[0];
			var theId = this.id;
			formatXmlInTextArea(contentTextArea);
			return false;
		});
		var formatXmlInTextArea = function(textArea) {
			var unFormatted = $(textArea).val();
			var formatted = format_xml(unFormatted);
			$(textArea).val(formatted);
			$(textArea).trigger("reformatted");
		}
	});

	$('.deleteFulfilledRequestLink').each( function() {
		$(this).click( function() {
			var requestId = this.id.split("_")[1];
			var unusedServiceId = -1;
			$.ajax({
				type: "GET",
				url: "<c:url value="history"/>?action=delete&serviceId="+unusedServiceId+"&fulfilledRequestId="+requestId
			});
			$('#fulfilledRequest_'+requestId).fadeOut(500, function() {
				$('#fulfilledRequest_'+requestId).remove();
			});
		});
	});
	
	$('.tagFulfilledRequestLink').each( function() {
		$(this).click( function() {
			var requestId = this.id.split("_")[1];
			var unusedServiceId = -1;
			$.ajax({
				type: "POST",
				url: "<c:url value="history"/>?action=tag&fulfilledRequestId="+requestId
			});
		});
	});
	
    $('a.tagFulfilledRequestLink').click(function () {
      $(this).parent().toggleClass("selected");
      var tagspan= $(this).find(".tag")[0];
      $(tagspan).toggle();
      var untagspan= $(this).find(".untag")[0];
      $(untagspan).toggle();
    });

	$('.viewFulfilledRequestLink_orig').each( function() {
		$(this).click( function() {
			var requestId = this.id.split("_")[1];	
		    $(this).toggle();		
		    $('#hideFulfilledRequest_'+requestId).toggle();
			$.ajax({
				type: "GET",
				url: "<c:url value="fulfilledrequest"/>?&fulfilledRequestId="+requestId,
				success: function(html) {
                  //i want to fade result into these 2 divs...
                  $('#letmesee_'+requestId).hide().html(html).fadeIn();
                }
			});
		});
	});

	$('.viewFulfilledRequestLink').each( function() {
        $(this).click( function() {
            var requestId = this.id.split("_")[1];  
            $(this).toggle();       
            $('#hideFulfilledRequest_'+requestId).toggle();
            $.ajax({
                type: 'GET',
                dataType: 'json',
                url: '<c:url value="/conversation/record"/>?&conversationRecordId='+requestId,
                success: function(data) {
                  //i want to fade result into these 2 divs...
                  //<textarea name="requestUrl_${request.id}" rows="5" cols="50"></textarea>
                  //<textarea name="requestParameters_${request.id}" rows="5" cols="50"></textarea>
                  //<textarea name="requestHeaders_${request.id}" rows="5" cols="50"></textarea>
                  //<textarea name="requestBody_${request.id}" rows="5" cols="50"></textarea>
                  $('#requestUrl_'+requestId).val(data.requestUrl);
                  $('#requestParameters_'+requestId).val(data.requestParameters);
                  $('#requestHeaders_'+requestId).val(data.requestHeaders);
                  $('#requestBody_'+requestId).val(data.requestBody);
                  $('#responseStatus_'+requestId).val(data.responseStatus);
                  $('#responseHeader_'+requestId).val(data.responseHeader);
                  $('#responseBody_'+requestId).val(data.responseBody);
                  $('#letmesee_'+requestId).show(); 
                  
                }
            });
        });
    });

	$('.save-as-a-service-scenario').button().click(function() {
		var serviceId = this.id.split("_")[1];
        // Clear input
        $('#scenario_name').val('');
        $('#scenario_match').val('');
        $('#scenario_response').val(''); 
        $('#dialog-create-scenario').dialog('open');
            $('#dialog-create-scenario').dialog({
                buttons: {
                  "Create scenario": function() {
                       var bValid = true;  
                       allFields.removeClass('ui-state-error');
                       bValid = bValid && checkLength(name,"scenario name",3,250);
                       if (bValid) {
                           $.post('<c:url value="/scenario"/>', { scenarioName: name.val(), serviceId: serviceId, matchStringArg: match.val(),
                                responseMessage: responsemsg.val() } ,function(data){
                                    
                                }, 'json' );  
                           $(this).dialog('close');              
                           document.location="<c:url value="/home" />?serviceId="+ serviceId;
                       }
                  }, 
                  Cancel: function(){
                      $(this).dialog('close');
                  }
                }
          }); 
          
          return false;
	});

	$('.hideFulfilledRequestLink').each( function() {
		$(this).click( function() {
			var requestId = this.id.split("_")[1];			
			$('#letmesee_'+requestId).fadeOut();
			$('#hideFulfilledRequest_'+requestId).toggle();
			$('#viewFulfilledRequest_'+requestId).toggle();
		});
	});

   
    $("#dialog-clear-history-confirm").dialog({
        resizable: false,
        height:120,
        modal: false,
        autoOpen: false
    });
        
    $('.clear_history').each( function() {
        $(this).click( function() {
            
            $('#dialog-clear-history-confirm').dialog('open');
                $('#dialog-clear-history-confirm').dialog({
                    buttons: {
                      "Delete history": function() {
                         document.location="<c:url value="/history?action=delete_all" />";                              
                      }, 
                      Cancel: function(){
                          $(this).dialog('close');
                      }
                    }
              }); 
              return false;
            });
        });
        
});

</script>
<div id="main">
    <h1>Service History: <span class="highlight"><c:out value="${mockservice.serviceName}"/></span></h1>
    <div id="dialog-clear-history-confirm" title="Delete history">Are you sure? This will delete all fulfilled requests for all requesting IPs.</div>
    <form action="<c:url value="/history"/>" method="get">
    <p>
    
    <input type="text" name="token" size="80" class="text ui-corner-all ui-widget-content"/>
    <button id="filter-button" >Add Filter</button>
    
    <c:if test="${!empty requests}">
      <c:url value="/history" var="deleteAllScenarioUrl">
         <c:param name="action" value="delete_all" />
      </c:url>
      <a  class="spread clear_history" href="#">Clear History</a>  
    </c:if>
    <c:if test="${!empty historyFilter.tokens}">  
       <a class="spread" href="<c:url value="/history?action=remove_all_tokens"/>">Clear Filters</a>
    </c:if>
    </p>
    </form>
    <c:if test="${!empty historyFilter.tokens}">    
    <p class="tiny">You are filtering your history on:<span style="float:right;"><strong>Hint:</strong> Try filtering with <i>bang + term</i>, example: <span class="code_text"><b>!term</b></span></span></p>
    <div class="hint_message">
   
    <p>
    <c:forEach var="token" items="${historyFilter.tokens}">
        ${token}<a id="token" class="remove_grey" title="Remove filter token" href="<mockey:history value="${token}"/>">x</a> 
    </c:forEach>
    </p>
    
    </div>
    </c:if>
    <c:choose>
        <c:when test="${!empty requests}">
            <c:forEach var="request" items="${requests}" varStatus="status">            
                <div id="fulfilledRequest_${request.id}" class="parentform" style="padding: 0.2em 0.5em; 0.2em 0.5em;">
                   <c:url value="/home" var="serviceUrl">
                          <c:param name="serviceId" value="${request.serviceId}" />                                                                               
                   </c:url>  
                   <div style="text-align:right;  position: relative;font-size:80%;" class="<c:if test="${request.comment ne null}">selected</c:if>">
                     
                     <a href="#" id="viewFulfilledRequest_${request.id}" class="viewFulfilledRequestLink" onclick="return false;">view</a>
                     <a href="#" id="hideFulfilledRequest_${request.id}" class="hideFulfilledRequestLink" onclick="return false;" style="display:none;">hide</a> |    
                     <a href="#" id="tagFulfilledRequestLink_${request.id}" class="tagFulfilledRequestLink" onclick="return false;"><span class="tag" style="<c:if test="${request.comment ne null}">display:none;</c:if>">tag</span><span class="untag" style="<c:if test="${request.comment eq null}">display:none;</c:if>">untag</span></a>
                     <a href="#" id="deleteFulfilledRequest_${request.id}" class="deleteFulfilledRequestLink remove_grey" style="margin-left:2em;">x</a>	              
	               </div>
	               <div style="width:720px; position:relative; margin-top:-1em;font-size:80%;">
	                 <b>When:</b> <mockey:fdate date="${request.time}"/> <b>From:</b> <a id="finfo" title="<c:out value="${request.requestorIP}"/>"><mockey:slug text="${request.requestorIP}" maxLength="25"/></a>
						 (<mockey:service style="1" type="${request.serviceResponseType}"/>)
	                 <b><a href="<c:out value="${serviceUrl}"/>" title="<c:out value="${request.serviceName}"/>"><mockey:slug text="${request.serviceName}" maxLength="20"/></a></b>
	                 <div style="padding-top:0.2em;">
	                 <b>URL:</b> <mockey:slug text="${request.rawRequest}" maxLength="180"/> </div>                    
	                 <div id="letmesee_orig${request.id}">
	                 
                     </div>
                     <div id="letmesee_${request.id}" style="display:none;">
                        <div>
                        <h3>Request</h3>
	                        
	                        <textarea id="requestUrl_${request.id}" name="requestUrl"></textarea>
	                        <textarea id="requestParameters_${request.id}" name="requestParameters" rows="5" cols="50"></textarea>
	                        <textarea id="requestHeaders_${request.id}"  name="requestHeaders" rows="5" cols="50"></textarea>
	                        <textarea id="requestBody_${request.id}" name="requestBody" rows="5" cols="50"></textarea>
	                        
                        </div>
                        <div>
                        <h3>Response</h3>
                            
                               <textarea id="responseStatus_${request.id}" name="responseStatus" rows="5" cols="50"></textarea>
                               <textarea id="responseHeader_${request.id}"  name="requestHeader" rows="5" cols="50"></textarea>
                               <textarea id="responseBody_${request.id}" name="responseBody" rows="5" cols="50"></textarea>
                            
                            <button class="save-as-a-service-scenario">Save me as a scenario</button>
                            
                        </div>
                     </div>
                   </div>                   
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p class="info_message">No history here. It's because no one talks to Mockey or someone just cleared the history. Mockey is feeling unwanted.</p>
        </c:otherwise>
    </c:choose>
    <jsp:include page="/WEB-INF/common/inc_scenario_create_dialog.jsp" />
</div>



<jsp:include page="/WEB-INF/common/footer.jsp" />