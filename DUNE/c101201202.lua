--coded by Lyris
--not fully implemented
--Revolution Synchron
local s, id, o = GetID()
function s.initial_effect(c)
	--hand synchro HOpT
	--snip 1: edited from "Malefic Paradox Gear"
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(id)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,id)
	c:RegisterEffect(e0)
	--end snip 1
	--register HOpT
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_PRE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e1:SetLabelObject(e0)
	e1:SetCondition(s.hsregcon)
	e1:SetOperation(s.hsynreg)
	c:RegisterEffect(e1)
	--spsum self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+100+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--hand synchro 
	--hand synchro --! may need EFFECT_EXTRA_SYNCHRO_MATERIAL
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(s.syncon)
	e3:SetTarget(s.syntg)
	e3:SetValue(SUMMON_TYPE_SYNCHRO)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_HAND)
	e4:SetTargetRange(LOCATION_EXTRA,0)
	e4:SetTarget(aux.TargetBoolFunction(s.hsynfilter0))
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function s.stfilter(c,tc)
	return c:IsCanBeSynchroMaterial() and c:IsNotTuner(tc)
end
function s.hsynfilter0(c)
	local syc=0
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local sc=Duel.GetMatchingGroup(s.stfilter,tp,LOCATION_MZONE,0,nil,c)
	local tu=Duel.GetMatchingGroup(s.tunefilter,tp,LOCATION_HAND,0,nil,tp)
	local tlv=tu:GetFirst():GetLevel()
	local maxct=99
	local minct=1
	if c:IsCode(4779823,25132288) then
		dc=sc:Filter(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
	elseif c:IsCode(88643579) then
		dc=sc:Filter(Card.IsAttribute,nil,ATTRIBUTE_DARK)
	elseif c:IsCode(41659072) then
		dc=sc:Filter(Card.IsAttribute,nil,ATTRIBUTE_EARTH)
	elseif c:IsCode(65749035) then
		dc=sc:Filter(Card.IsAttribute,nil,ATTRIBUTE_WATER)
	elseif c:IsCode(67797569) then
		dc=sc:Filter(Card.IsAttribute,nil,ATTRIBUTE_FIRE)
	elseif c:IsCode(90036274) then
		dc=sc:Filter(Card.IsAttribute,nil,ATTRIBUTE_WIND)
	elseif c:IsCode(40529384) then
		dc=sc:Filter(Card.IsRace,nil,RACE_DRAGON)
	elseif c:IsCode(18239909) then
		dc=sc:Filter(Card.IsType,nil,TYPE_PENDULUM)
	elseif c:IsCode(50954680) then
		dc=sc:Filter(Card.IsType,nil,TYPE_SYNCHRO)
	elseif c:IsCode(70771599) then
		dc=sc:Filter(Card.IsType,nil,TYPE_PENDULUM):Filter(Card.IsAttribute,nil,ATTRIBUTE_DARK)
	elseif c:IsCode(96029574) then
		dc=sc:Filter(Card.IsType,nil,TYPE_DUAL)
	elseif c:IsCode(25165047) then
		dc=sc:Filter(Card.IsCode,nil,2403771)
		maxct=1
	else
		dc=sc
	end
	return c:IsType(TYPE_SYNCHRO) and (c:IsLevel(7,8) and c:IsRace(RACE_DRAGON) or c:IsSetCard(0xc2)) and dc:CheckWithSumEqual(Card.GetSynchroLevel,lv-tlv,minct,maxct,c) and not c:IsCode(25682811,39823987,58074177,80159717,95453143,36556781)
end
function s.hsregcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and s.hsynfilter(c:GetReasonCard()) and c:IsPreviousLocation(LOCATION_HAND)
end
function s.hsynreg(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():UseCountLimit(tp)
end
function s.hsynfilter(c,tc)
	return c:IsType(TYPE_SYNCHRO) and (c:IsLevel(7,8) and c:IsRace(RACE_DRAGON) or c:IsSetCard(0xc2)) and c:IsSynchroSummonable(tc)
end
function s.tunefilter(c,tp)
	return c:IsType(TYPE_TUNER) and c:IsHasEffect(id,tp)
end
function s.syncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_MZONE,0,nil) 
	return Duel.GetFlagEffect(tp,id)==0 and sc:GetCount()>0
end
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	local sc=Duel.GetMatchingGroup(s.tunefilter,tp,LOCATION_HAND,0,nil,tp)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,1)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
		local sg=Duel.SelectMatchingCard(tp,s.tunefilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
		if sg and Duel.MoveToField(sg,tp,tp,LOCATION_MZONE,POS_FACEUP,true) then
		Duel.AdjustAll()
		if not sg:IsLocation(LOCATION_MZONE) then return end
		local g=Duel.GetMatchingGroup(s.hsynfilter,tp,LOCATION_EXTRA,0,nil,sg)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local ssg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,ssg:GetFirst(),sg)
		end
	end
	Duel.SpecialSummonComplete()
end
function s.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.SelectMatchingCard(tp,s.tunefilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	if sc:GetCount()>0 and Duel.MoveToField(sc,tp,tp,LOCATION_MZONE,POS_FACEUP,true) then
		Duel.AdjustAll()
		if not sc:IsLocation(LOCATION_MZONE) then return end
		local g=Duel.GetMatchingGroup(s.hsynfilter,tp,LOCATION_EXTRA,0,nil,sc)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),sc)
		end
	end
	Duel.SpecialSummonComplete()
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(7) and c:IsType(TYPE_SYNCHRO)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--snip 2: edited from "Glow-Up Bulb"
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,1,REASON_EFFECT)~=0 then
		local oc=Duel.GetOperatedGroup():GetFirst()
		local c=e:GetHandler()
		if oc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			--snip 3: edited from "Gagaga Girl"
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
			--end snip 3
		end
		Duel.SpecialSummonComplete()
	end
end
--end snip 2
