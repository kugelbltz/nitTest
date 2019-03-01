# Ceci est un commentaire
print 1+1

var a = 12
var b = a.to_f/7.0

print "a = {a}, b = {b}"

print """- Bonjour " { comment allez vous ?
- Je vais très bien et vous ?
- Très bien. Quelle âge avez vous ?
- J'ai {{{ a + 19 }}} ans."""

var x: String
x = 5.to_s
print x

var t = [1, 2, 3, 4]
print t.join(":")
var t2 = new Array[Int]
t2.add(10)
t2.add_all(t)
t2.add(20)
print t2[0]
print t2.length
t2[1] = 30
print t2.join(" ")

print([1..5[.join(" "))
print([1..5].join(" "))

var h = new HashMap[String, Int]
h["six"] = 6
print h["six"] + 1

var r = 2

if r > 2 then
        print "sup"
else if r < 2 then
        print "inf"
else
        print "egal"
end
#if exp then stm

var i = 0
while i < 10 do
        print i
        i += 1
end
# while exp do stm

for y in [9..4[.step(-1) do print y

loop
        i -= 1
        if i < 0 then break
end
