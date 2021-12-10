var lastCursorPosition = 0;
let meta_pressed = false;
let shift_pressed = false;

function handleKeyDown(e) {
  switch (e.key) {
    case 'Shift':
      shift_pressed = true;
      break;
    case 'Meta':
      meta_pressed = true;
      break;
    case 'Enter':
      if(meta_pressed) {
        Rails.fire($('#page_form')[0], 'submit');
      }
      break;
    case 'Tab':
      if(shift_pressed) {
        e.preventDefault();
        removeTab();
      }
      else {
        e.preventDefault();
        var _lb = lookBehind();
        if(_lb) {
          var _expand = expand(_lb);
          if (_expand) {
            appendHTML(_expand);
          }
        }
        else {
          appendHTML("\t__$__", false);
        }
      }
      break;
    default:
      break;
  }
}

function handleKeyUp(e) {
  switch (e.key) {
    case 'Meta':
      meta_pressed = false;
      break;
    case 'Shift':
      shift_pressed = false;
      break;
    default:
      false
      break;
  }
}



function expand(init) {
  let _class = null;
  let _id = null;
  let _interiorText = "__$__";
  let _remainingInput = init;

  if(init.match(/\./)) {
    _class = init.match(/(?<=\.)\w*/)[0]
  }
  if(init.match(/\#/)) {
    _id = init.match(/(?<=#)\w*/)[0]
  }

  if(init.match(/{.*}/)) {
    _interiorText = init.match(/(?<={)\w*(?=})/)[0] + "__$__"
  }
  else {
    _interiorText = "__$__"
  }

  if(_class || _id) {
    _remainingInput= init.match(/^(.*?)(?=[\.#{])/)[0]
  }
  if(_interiorText) {
    _remainingInput = _remainingInput.replace(`{${_interiorText.replace("__$__", "")}}`, '')
  }
  if(_remainingInput == "") {
    _remainingInput= 'div';
  }

  let classText = _class ? ` class="${_class}"` : ""
  let idText = _id ? ` id="${_id}"` : ""

  var expandedHtml = `<${_remainingInput}${idText}${classText}>${_interiorText}</${_remainingInput}>`
  return handleHtmlElement(_remainingInput, expandedHtml);
}

function handleHtmlElement(elementName, html) {
  switch (elementName) {
    case 'ul':
      return html.replace("__$__", "\n\t<li>__$__</li>\n")
      break;
    case 'a':
      return html.replace("<a", "<a href=''")
      break;
    case 'p':
      return html
      break;
    default:
      return html;
      break;

  }
}

function appendHTML(element, replace = true) {
  var currentValue = $('#page_form textarea').val()
  var selectionStart = $('#page_form textarea')[0].selectionStart; //Get the current cursor position

  //Delete original element
  var _lookBehind = lookBehind();
  var deleteStart = selectionStart - _lookBehind.length;
  let deleteEnd = selectionStart;
  if(replace) {
    $('#page_form textarea').selectRange(deleteStart, selectionStart);
    document.execCommand('cut', false); //Add it to the value
    // Add new element
    currentValue = $('#page_form textarea').val()
    var combinedText = currentValue.slice(0, deleteStart) + element + currentValue.slice(deleteStart); //Splice in the new element into the existing one
    $('#page_form textarea').selectRange(deleteStart);

    var range = combinedText.indexOf("__$__"); //Get the actual index of the selector
    document.execCommand('insertText', false, element.replace("__$__", "")); //Add it to the value
    $('#page_form textarea').selectRange(range);
  }
  else {
    $('#page_form textarea').selectRange(selectionStart);
    var combinedText = currentValue.slice(0, selectionStart) + element + currentValue.slice(selectionStart);
    var range = combinedText.indexOf("__$__");
    document.execCommand('insertText', false, element.replace("__$__", "")); //Add it to the value
    $('#page_form textarea').selectRange(range);
  }
}

function removeTab() {
  var currentValue = $('#page_form textarea').val();
  let _currentSelection = currentSelection();

  if(currentValue[_currentSelection - 1].match(/\t/)) {
    var newVal = currentValue.slice(0, _currentSelection - 1) + currentValue.slice(_currentSelection)
    $('#page_form textarea').val(newVal);
    $("#page_form textarea").selectRange(_currentSelection - 1);
  }
}

function currentSelection(offset = 0) {
  return $('#page_form textarea')[0].selectionStart + offset;
}

function lookBehind() {
  var selectionStart = $('#page_form textarea')[0].selectionStart; //Get the current cursor position
  var val = $('#page_form textarea').val();
  var behind = val[selectionStart - 1];
  if(!behind || behind.match(/[>\s]/)) {
    return false;
  }

  var isValid = behind.match(/[^\s]/)
  if(isValid) {
    let textBeforeCursor = val.slice(0, selectionStart)
    let lastNonWhiteSpace = textBeforeCursor.match(/(?<=\s)\S+$/)
    if(lastNonWhiteSpace) {
      lastNonWhiteSpace = lastNonWhiteSpace[0]
    }
    else {
      if(val != "") {
        lastNonWhiteSpace = val;
      }
      else {
        return false;
      }
    }
    return lastNonWhiteSpace;
  }
}

$.fn.selectRange = function(start, end = null) {
    if(!end) {
        end = start;
    }
    console.log(start, end);
    return this.each(function() {
        if('selectionStart' in this) {
            this.selectionStart = start;
            this.selectionEnd = end;
        } else if(this.setSelectionRange) {
            this.setSelectionRange(start, end);
        } else if(this.createTextRange) {
            var range = this.createTextRange();
            range.collapse(true);
            range.moveEnd('character', end);
            range.moveStart('character', start);
            range.select();
        }
    });
};



function insertMonster(monsterId) {
  insertElement(id, "monster")
}

function insertSpell(spellId) {
  insertElement(id, "spell")
}

function insertMagicItem(id) {
  insertElement(id, "magic_item")
}

function insertElement(id, type) {
  if($("#page_form textarea").length == 0) {
    return;
  }
  $("#page_form textarea").focus();
  $("#page_form textarea").selectRange(lastCursorPosition);
  appendHTML(`<${type} id="${id}"></${type}>__$__`, false);

  switch (type) {
    case "monster":
      $("#monster_card").html('');
      break;
    default:
      hideActiveSpell();
      break;
  }
}
