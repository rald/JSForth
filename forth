#!/bin/node

var stack=[];
var words={};

function eval(s) {  
  var t=s.split(/\s+/).filter(i => i);
  var tn=t.length;
  var i=0;
  while(i<tn) {
    var v=t[i].trim();
    if(v) {
      if(!isNaN(parseInt(v))) {
        stack.push(parseInt(v));
      } else {
        switch(v) {
          case ':':
            i++;
            if(i>=tn) {
              console.log("Error: no word name in definition")
              process.exit(-1);
            }
            var n=t[i].trim(); 
            var d="";
            i++;
            if(i>=tn) {
              console.log("Error: no definition terminator")
              process.exit(-1);
            }
            while(t[i]!=';') {
              d+=t[i]+" "; 
              i++;
              if(i>=tn) {
                console.log("Error: no definition terminator")
                process.exit(-1);
              }
            } 
            words[n]=d;
          break;
          case '.':
            process.stdout.write(stack.pop().toString());
          break;
          case '+':
            stack.push(stack.pop()+stack.pop());
          break;
          case '-':
            y=stack.pop();
            x=stack.pop();
            stack.push(x-y);
          break;
          case '*':
            stack.push(stack.pop()*stack.pop());
          break;
          case '/':
            y=stack.pop();
            x=stack.pop();
            stack.push(Math.floor(x/y));
          break;
          case "DUP":
            x=stack.pop();
            stack.push(x);
            stack.push(x);
          break;
          case "DROP":
            stack.pop();
          break;
          case "SWAP":
            y=stack.pop();
            x=stack.pop();
            stack.push(x);
            stack.push(y);
          break;
          case "OVER":
            stack.push(stack[0]);
          break;
          case "EMIT":
            process.stdout.write(String.fromCharCode(stack.pop()));
          break;
          case "REPEAT":
            var c=stack.pop();
            i++;
            if(i>=tn) {
              console.log("Error: no word name")
              process.exit(-1);
            }
            var n=t[i];
            for(var j=0;j<c;j++) eval(n);
          break;
          case "RAND":
            stack.push(Math.floor(Math.random()*stack.pop()))
          break;
          default:
            if(v in words) {
              eval(words[v]);
            } else {
              console.log("Error: undefined word: "+v);
              process.exit(-1);
            }
        }
      }
    }
    i++;
  }
}

const fs=require('fs');
var filename=process.argv[2];

console.log(filename);

fs.readFile(filename,'utf8',function(err, data) { 
  eval(data); 
}); 
