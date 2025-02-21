--クッキィ★ヤミーウェイ
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.LSynCondition)
	e0:SetTarget(s.LSynTarget)
	e0:SetOperation(Auxiliary.SynOperation())
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	c:EnableReviveLimit()
	--position change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tdcon)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.matfilter1(c,syncard,tp)
	if c:IsFacedown() then return false end
	if c:IsSynchroType(TYPE_LINK) and c:IsControler(tp) then return true end
	return c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard) and (c:IsControler(tp) or Duel.GetSynchroMaterial(tp):IsContains(c))
end
function s.matfilter2(c,syncard,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsNotTuner(syncard) and c:IsCanBeSynchroMaterial(syncard) and (c:IsControler(tp) or Duel.GetSynchroMaterial(tp):IsContains(c))
end
function s.val(c,syncard)
	if c:IsSynchroType(TYPE_LINK) then
		return c:GetLink()
	else
		return c:GetSynchroLevel(syncard)
	end
end
function s.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	return tsg:CheckSubGroup(s.goal,minc,maxc,tp,lv,syncard,c)
end
function s.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local lg=g:__add(tuc)
	return lg:CheckWithSumEqual(s.val,lv,#lg,#lg,syncard)
end
function s.LSynCondition(e,c,tuner,mg,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=1
	local maxc=c:GetLevel()-1
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(s.matfilter1,nil,c,tp)
		g2=mg:Filter(s.matfilter2,nil,c,tp)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g3=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c,tp)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return s.matfilter1(c,tp) and s.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	elseif pe then
		return s.matfilter1(pe:GetOwner(),tp) and s.synfilter(pe:GetOwner(),c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(s.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function s.LSynTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg,min,max)
	local minc=1
	local maxc=c:GetLevel()-1
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(s.matfilter1,nil,c,tp)
		g2=mg:Filter(s.matfilter2,nil,c,tp)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g3=Duel.GetMatchingGroup(s.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c,tp)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuc=tuner
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local sg=g1:Filter(s.synfilter,nil,c,lv,g2,g3,minc,maxc,tp):CancelableSelect(tp,1,1,nil)
			if sg then
				tuc=sg:GetFirst()
			else
				return false
			end
		else
			tuc=pe:GetOwner()
			Group.FromCards(tuc):Select(tp,1,1,nil)
		end
	end
	local tsg=tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	Duel.Hint(tp,HINT_SELECTMSG,HINTMSG_SMATERIAL)
	local g=tsg:SelectSubGroup(tp,s.goal,true,minc,maxc,tp,lv,c,tuc)
	if g then
		g:AddCard(tuc)
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetsRelateToChain():Filter(Card.IsType,nil,TYPE_MONSTER)
	if #sg==0 then return end
	Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x2c8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler(),tp)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if ft==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end