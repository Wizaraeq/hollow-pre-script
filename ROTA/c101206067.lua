--共闘闘君
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--increase atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.atkcost)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	if s.counter==nil then
		s.counter=true
		s[0]=0
		s[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(s.resetcount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_DESTROYED)
		ge2:SetOperation(s.addcount)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.resetcount(e,tp,eg,ep,ev,re,r,rp)
	s[0]=0
	s[1]=0
end
function s.addcount(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tc=eg:GetFirst()
	while tc do
		if (ph>PHASE_MAIN1 and ph<PHASE_MAIN2) and tc:IsType(TYPE_TOKEN) then
			local p=tc:GetPreviousControler()
			s[p]=s[p]+1
		end
		tc=eg:GetNext()
	end
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.costfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN) and Duel.IsExistingTarget(s.matfilter1,tp,LOCATION_MZONE,0,1,c,tp,Group.FromCards(c))
end
function s.matfilter1(c,tp,g)
	local sg=g:Clone()
	sg:AddCard(c)
	return c:IsFaceup() and c:IsAttack(0) 
end
function s.fselect(g,tp)
	return Duel.IsExistingTarget(s.matfilter1,tp,LOCATION_MZONE,0,1,g,tp,g)
		and Duel.CheckReleaseGroup(tp,aux.IsInGroup,#g,nil,g)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.matfilter1(chkc,tp,g) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		return Duel.CheckReleaseGroup(tp,s.costfilter,1,nil,tp)
	end
	local rg=Duel.GetReleaseGroup(tp):Filter(s.costfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,s.fselect,false,1,rg:GetCount(),tp)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	aux.UseExtraReleaseCount(sg,tp)
	Duel.Release(sg,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.matfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,sg)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetCount()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(ct-1)
		tc:RegisterEffect(e2)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=s[tp]+s[1-tp]
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH) end
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetLabel()
	if ft>0 and ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH) then
		local count=math.min(ft,ct)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then count=1 end
		if count>1 then
			local num={}
			local i=1
			while i<=count do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
			count=Duel.AnnounceNumber(tp,table.unpack(num))
		end
		repeat
			local token=Duel.CreateToken(tp,id+o)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			count=count-1
		until count==0
		Duel.SpecialSummonComplete()
	end
end