pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--questions 

data="\nwie hoch ist der mt. everest?;6058 m,7895 m,8848 m,9010 m;3:\
wie viele einwohner hat \noesterreich?;6 mio,8 mio,9 mio,12 mio;3:\
wie lange ist die donau?;1253 km,2850 km,3593 km,4456 km;2:\
wann war der 2. weltkrieg?;1914-18,1925-30,1939-45,1955-62;3:\
wie tief ist der marianengraben?;8 km,11 km,15 km,18 km;2"


-->8
--main

function _init()
	qc=1
	qt=0
	correct=0
	incorrect=0
	selected_a=1
	select_pos=16
	questions={}
	textcolor=rnd({3,4,8,9,10,11,12,13,14,15})
	
	--function to create question-object
 function create_question(text,choices,correct)
  q={} 
 	q.text = text
 	q.choices = choices
 	q.correct = correct
 	
 	return q
 end

 --parse "data" and create a question
	data_questions=split(data,":")
	for q in all(data_questions) do
  local	elements=split(q,";")
		local text=elements[1]
		local	choices=split(elements[2],",")
		local correct=elements[3]
		add(questions,create_question(text,choices,correct))
	end
 
 --init random question
 qt=#questions
	questionnum=flr(rnd(#questions))+1
end

function _update()
 --move selection-box
	if btnp(3) then
		select_pos+=8
		selected_a+=1
	end
	
	if btnp(2) then
		select_pos-=8
		selected_a-=1
	end
	
	--commit selection
	if btnp(5) then
		if #questions > 0 then
			if qc < qt then qc+=1 end
			textcolor=rnd({3,4,8,9,10,11,12,13,14,15})
			if selected_a == questions[questionnum].correct then
				correct += 1
				sfx(3)
			else
				incorrect += 1
				sfx(2)
			end
			select_pos=16
			selected_a=1	
	end
		
		--delete anwsered question
		del(questions,questions[questionnum]) 
		questionnum=flr(rnd(#questions))+1
	end
	
	--selection-box reset position 
	if selected_a > 4 then
		select_pos = 16
		selected_a = 1
	end
	
	if selected_a < 1 then
		select_pos = 40
		selected_a = 4
	end
end

function _draw()
 cls()

 --draw questions and choices
	if #questions > 0 then
		print(questions[questionnum].text,0,0,textcolor)
		n=0
	 for c in all(questions[questionnum].choices) do
	 	print(c,4,n * 8 + 28,7)
	 	n+=1
		end	
		rect(0,select_pos+10,48,select_pos+18,12)
	else
		print("fertig...",45,50,10)
	end

 --draw state	
	print("frage "..qc .. " von " .. qt,0,110,7)
	print("richtig: ".. correct,0,119,11)
	print("falsch: ".. incorrect ,64,119,8)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000200001f0501d0501b050190501705016050140501305012050100500e0500d0500b0500a050090500200002000020000d0000d0000d00005000010000c0000c0000c0000c0000c0000c0000b0000b00000000
0005000026050280502a0502e05032050000000e7000d7001070010700107002130017300133000d300203000a3000a3000e3000f300243001300015000142000d2000a2000a2000d2001b200107001570017700
000600000435004350043500435004350043500030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002a3502b3502c3502d3502e350303503135000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010001c2735024350233502335024350263502a3502c3502d3502e3502d3502b350283502535022350213501f3501b3501a3501935019350193501a3501b3501c35020350233502635000000000000000000000
__music__
00 04424344

