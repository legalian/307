


import glob
import re
from sys import exit
import sys
from collections import OrderedDict as ODict

class Map:
	def __init__(self):
		self.props = []
		self.sub_resource_id = 1
		self.exmaps = {}
	def __str__(self):
		res = '[gd_scene load_steps=20 format=2]\n\n'
		def tostr(obj):
			if '___id' in obj: obj['id'] = obj['___id']
			if '___parent' in obj: obj['parent'] = obj['___parent']
			propslist = [obj['___type']]+[k+'='+v for k,v in obj.items() if not k.startswith('___')]
			res='['+' '.join(propslist)+']\n'
			for k,v in obj['___lines'].items(): res+=k+' = '+v+'\n'
			return res

		for obj in self.props:
			if obj['___type']=='ext_resource': res += tostr(obj)
		if any(obj['___type']=='ext_resource' for obj in self.props): res += "\n"
		for obj in self.props:
			if obj['___type']=='sub_resource': res += tostr(obj)+'\n'
		for obj in self.props:
			if obj['___type']=='node': res += tostr(obj)+'\n'
			
		return res
	def isCallOf(self,call,func):
		if call.startswith(func+'('): return int(call[len(func+'('):-len(')')])
	def getBodyDict(self,text):
		res = ODict()
		for line in (o for o in text.split('\n') if len(o)):
			first = line.find(' = ')
			res[line[:first]] = line[first+len(' = '):]
		return res
	def reformBodyDict(self,dict):
		res = ""
		for k,v in dict:
			res += k+" = "+v+"\n"
		return res+"\n"
	def whitelist(self,dict,ok_keys):
		return ODict([(k,v) for k,v in dict.items() if k in ok_keys])
	def assertNotHaveScale(self,obj):
		if 'scale' in obj['___lines']:
			print("The script has determined that there is a collision object in the map that has a scaling directly or indirectly applied to it.")
			print("This causes undefined behavior and instability within the physics engine and must be resolved before further development.")
			print("The object with the scaling is named: "+str(obj.get('name')))
			print("The script will now abort without outputting anything.")
			exit(1)
	def addPathSegment(self,path,seg):
		if path=='.': return seg
		return path+'/'+seg
	def read(self,path,parentpath=None,savedir=None):
		with open(path,'r') as f: doc = f.read()
		props = []
		lb = None
		for x in re.finditer(r'(?<=\n)\[([^\"\'\[\]]|\"[^\"]*\"|\'[^\']*\')*\]\n',doc):
			blar = re.findall(r'(?:[^ \"\'\[\]\(\)]|\"[^\"]*\"|\'[^\']*\'|\([^\(\)]*\))+', x.group()[1:-2])
			obj = ODict()
			obj['___type'] = blar[0]
			obj['___important'] = False
			for k,v in (x.split('=') for x in blar[1:]): obj[k]=v
			if lb!=None: props[-1]['___lines']=self.getBodyDict(doc[lb:x.span()[0]])
			props.append(obj)
			lb = x.span()[1]
		if lb!=None: props[-1]['___lines']=self.getBodyDict(doc[lb:])

		def findMatch(propmatches):
			for i in range(len(props)):
				if all(props[i].get(k)==v for k,v in propmatches.items()): return i
		def markImportant(propmatches):
			# print("SEARCHING",parentpath,"FOR",propmatches)
			for obj in props:
				#if 'parent' in obj: print(obj['parent'])
				if obj['___important'] and '___important' not in propmatches: continue
				# if obj['___type']=='node': print("blah",{k:v for k,v in obj.items() if k!='___lines'})
				if all(obj.get(k)==v for k,v in propmatches.items()):
					# if obj['___type']=='node': print("MATCHED",parentpath,"FOR",{k:v for k,v in obj.items() if k!='___lines'})
					if obj['___type']=='sub_resource':
						if path not in self.exmaps: self.exmaps[path] = {}
						if obj['id'] not in self.exmaps[path]:
							self.exmaps[path][obj['id']]=str(self.sub_resource_id)
							self.sub_resource_id+=1
							obj['___id']=self.exmaps[path][obj['id']]
						else:
							obj['___id']=self.exmaps[path][obj['id']]
							continue
					if obj['___type']=='node': self.assertNotHaveScale(obj)
					# if 'parent' not in obj: print(obj)
					if 'parent' in obj:
						assert obj['parent'][0]=='"' and obj['parent'][-1]=='"'

						if obj['parent']=='"."':
							if parentpath!=None: obj['___parent'] = '"'+parentpath+'"'
							# print("marking none")
							markImportant({'___type':'node','parent':None})
						elif '/' not in obj['parent']:
							if parentpath!=None: obj['___parent'] = '"'+parentpath+'/'+obj['parent'][1:-1]+'"'
							# print(" "*38,"09049u50249802398450298340958","marking .")
							markImportant({'___type':'node','name':obj['parent'],'parent':'"."'})
						else:
							if parentpath!=None: obj['___parent'] = '"'+parentpath+'/'+obj['parent'][1:-1]+'"'
							vsp = obj['parent'][1:-1].split('/')
							# print("marking ",'"'+'/'.join(vsp[:-1])+'"')
							markImportant({'___type':'node','name':'"'+vsp[-1]+'"','parent':'"'+'/'.join(vsp[:-1])+'"'})
					if 'shape' in obj['___lines']:
						ori = str(self.isCallOf(obj['___lines']['shape'],'SubResource'))
						markImportant({'___type':'sub_resource','id':ori})
						obj['___lines']['shape'] = 'SubResource( '+self.exmaps[path][ori]+" )"
					if obj['___type']=='node' and obj.get('type') != '"CollisionShape2D"':
						obj['___lines'] = self.whitelist(obj['___lines'],['position','rotation','mode'])
						if obj.get('type') not in ['"RigidBody2D"','"StaticBody2D"','"KinematicBody2D"']:
							obj['type']='"Node2D"'
					obj['___important']=True

		for i in range(len(props)):
			if 'instance' in props[i]:
				scene = props[findMatch({'___type':'ext_resource','type':'"PackedScene"','id':str(self.isCallOf(props[i]['instance'],'ExtResource'))})]
				newobj = self.read(scene['path'].replace('res:/','Client')[1:-1],self.addPathSegment(props[i]['parent'][1:-1],props[i]['name'][1:-1]))
				newobj.update(self.whitelist(props[i],['name','parent']))
				newobj['___lines'].update(self.whitelist(props[i]['___lines'],['position','rotation']))
				props[i] = newobj

		markImportant({'___important':True})
		markImportant({'___type':'node','type':'"CollisionShape2D"'})
		res = None
		if parentpath!=None: res = props.pop(findMatch({'___type':'node','parent':None}))
		else:
			props[findMatch({'___type':'node','parent':None})]['___lines']['script'] = 'ExtResource( 1 )'
			props.append(ODict([
				('___type','ext_resource'),
				('___lines',ODict()),
				('___important',True),
				('path','"'+savedir.replace('Server/','res://')+'World.gd"'),
				('type','"Script"'),
				('id','1'),
			]))
		inspr = []
		for obj in props:
			if obj['___important']:
				del obj['___important']
				inspr.append(obj)
		self.props = inspr+self.props
		return res


if len(sys.argv)<2:
	print("\tscript needs one argument. Example: BattleRoyale/GrasslandWorld.tscn")
	print("\tfor that example, input path will be Client/minigames/BattleRoyale/GrasslandWorld.tscn")
	print("\tand output path will be Server/BattleRoyale/GrasslandWorld.tscn")
	exit(1)

path ="Client/minigames/"+sys.argv[1]
serverpath ="Server/"+sys.argv[1]
print("converting",path,"to",serverpath)
thismap = Map()
thismap.read(path,savedir=serverpath[:-len('World.tscn')])
outp = str(thismap)
# print("\t"+outp.replace('\n','\n\t'))
with open(serverpath,'w') as f: f.write(outp)





