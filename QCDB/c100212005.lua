--覇王龍ズァーク－シンクロ・ユニバース
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnableChangeCode(c,13331639)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(s.matfilter),1)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Special Summon this card from Pendulum Zone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	--Special Summon 2 "Supreme King Dragon" monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(s.spcon3)
	c:RegisterEffect(e3)
	--pendulum
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,2))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(s.pencon)
	e8:SetTarget(s.pentg)
	e8:SetOperation(s.penop)
	c:RegisterEffect(e8)
end
function s.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_PENDULUM)
end
function s.cfilter1(c,tp)
	return c:IsSetCard(0x10f8,0x20f8) and c:IsType(TYPE_PENDULUM) and Duel.GetMZoneCount(tp,c)>0 and (c:IsFaceup() or c:IsControler(tp))
end
function s.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.cfilter1,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,s.cfilter1,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(SET_SUPREME_KING_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.spfilter(c,e,tp)
	if not (c:IsSetCard(0x20f8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,g,c)>0
	else
		return Duel.GetMZoneCount(tp,g)>0
	end
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
end
function s.exfilter2(c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function s.exfilter3(c)
	return c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_LINK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
end
function s.gcheck(g,ft1,ft2,ft3,ect,ft)
	return aux.dncheck(g) and #g<=ft
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)<=ft1
		and g:FilterCount(s.exfilter2,nil)<=ft2
		and g:FilterCount(s.exfilter3,nil)<=ft3
		and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ect
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	local ft3=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM+TYPE_LINK)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		if ft3>0 then ft3=1 end
		ft=1
	end
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
	local loc=0
	if ft1>0 then loc=loc+LOCATION_DECK+LOCATION_GRAVE end
	if ect>0 and (ft2>0 or ft3>0) then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,loc,0,nil,e,tp)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=sg:SelectSubGroup(tp,s.gcheck,false,1,2,ft1,ft2,ft3,ect,ft)
	Duel.SpecialSummon(rg,0,tp,tp,false,false,POS_FACEUP)
end
function s.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end