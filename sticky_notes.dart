/*
 * This is just a simple Dart Sticky Post Application to showcase Drag and Drop and HTML5 Local Storage
 * Author: Ryan G. Gonzales
 * Author URL: http://www.mojobitz.com
 */

import 'dart:html';

Element dragSourceEl;
Element dropTarget;
var numberOfStickies = 0;

void main() {
  loadStickyData();
  query("#addPostIt").onClick.listen(addSticky);
  query("#reset").onClick.listen(resetData);
  
  eventListener();
}

void addSticky(MouseEvent event) {
  generateSticky(numberOfStickies);
  numberOfStickies++;
  saveStickyData();
  
  eventListener();
}

void eventListener(){
  queryAll(".stickyNotes").onDragStart.listen(dragStart);
  queryAll(".stickyNotes").onDragEnd.listen(dragEnd);
  queryAll(".stickyNotes").onDragEnter.listen(dragEnter);
  queryAll(".stickyNotes").onDragOver.listen(dragOver);
  queryAll(".stickyNotes").onDragLeave.listen(dragLeave);
  queryAll(".stickyNotes").onDrop.listen(dragDrop);
  queryAll(".remove").onClick.listen(removeSticky);
}

generateSticky(stickies){
  //Insert Sticky Paper
  var newSticky = new LIElement();
  var newStickyId = "sticky-"+stickies.toString();
  var queryStickyId = "#" + newStickyId;
  newSticky.classes.add("stickyNotes");
  newSticky.attributes['id'] = newStickyId;
  newSticky.attributes['draggable'] = "true";
  query("#sticky_board").children.add(newSticky);
  
  //InsertSticky Content
  var stickyTitle = query("#title");
  var stickyContent = query("#description");
  var stickyNoteText = "<h2>"+stickyTitle.value+"</h2><p>"+stickyContent.value+"</p><button class='remove' id='remove-"+stickies.toString()+"'>Remove</button>";
  query(queryStickyId).appendHtml(stickyNoteText);
  
  stickyTitle.value = "";
  stickyContent.value = "";
}

void removeSticky(MouseEvent event) {
  Element stickyData = event.target;
  stickyData.parent.remove();
  saveStickyData();
}

void dragStart(MouseEvent event) {
  //print(event.type);
  Element dragTarget = event.target;
  window.console.log(dragTarget);
  dragTarget.classes.add('moving');
  dragSourceEl = dragTarget;
  event.dataTransfer.effectAllowed = 'move';
  event.dataTransfer.setData('text/html', dragTarget.innerHtml);
}

void dragEnd(MouseEvent event) {
  Element dragTarget = event.target;
  dragTarget.classes.remove('moving');
  var cols = document.queryAll('#sticky_board .stickyNotes');
  for (var col in cols) {
    col.classes.remove('over');
  }
}

void dragEnter(MouseEvent event) {
  Element dropTarget = event.target;
  dropTarget.classes.add('over');
}

void dragOver(MouseEvent event) {
  // This is necessary to allow us to drop.
  event.preventDefault();
  event.dataTransfer.dropEffect = 'move';
}

void dragLeave(MouseEvent event) {
  Element dropTarget = event.target;
  dropTarget.classes.remove('over');
}

void dragDrop(MouseEvent event) {
  // Don't do anything if dropping onto the same column we're dragging.
  Element dropTarget = event.target;
  if (dragSourceEl != dropTarget && dropTarget.className == "stickyNotes over") {
    // Set the source column's HTML to the HTML of the column we dropped on.
    dragSourceEl.innerHtml = dropTarget.innerHtml;
    dropTarget.innerHtml = event.dataTransfer.getData('text/html');
  }else if (dragSourceEl != dropTarget && dropTarget.className != "stickyNotes") {
    // If the drop zone is not in the <li> then we'll change the drop target to the parent
    dragSourceEl.innerHtml = dropTarget.parent.innerHtml;
    dropTarget.parent.innerHtml = event.dataTransfer.getData('text/html');
  }
  
  queryAll(".remove").onClick.listen(removeSticky);
  saveStickyData();
}

void loadStickyData(){
  if(window.localStorage['savedStickies'] != "" && window.localStorage['savedStickies'] != null){
    document.query("#sticky_board").innerHtml = window.localStorage['savedStickies'];
    var getLastStickiesID = query("#sticky_board").children.last.id;
    var trimStickies = getLastStickiesID.split("-");
    numberOfStickies = int.parse(trimStickies[1])+1;
  }
}

void resetData(MouseEvent event){
  document.query("#sticky_board").innerHtml = "";
  numberOfStickies = 0;
  saveStickyData();
}

void saveStickyData(){
  if(query("#sticky_board").children.length != 0){
    var getStickyUL = document.query("#sticky_board").innerHtml;
    window.localStorage['savedStickies'] = getStickyUL;
  }else{
    window.localStorage['savedStickies'] = "";  
  }
}