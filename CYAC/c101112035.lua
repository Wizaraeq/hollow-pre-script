--真炎竜アルビオン
function c101112035.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,68468459,c101112035.mfilter,1,true,true)
	--Cannot be Fusion Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Cannot be targeted by the opponent's effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Special Summon 2 monsters from the GYs
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101112035,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101112035)
	e3:SetCondition(c101112035.spcon1)
	e3:SetTarget(c101112035.sptg1)
	e3:SetOperation(c101112035.spop1)
	c:RegisterEffect(e3)
	--Special Summon itself from the GY
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101112035,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,101112035+100)
	e4:SetTarget(c101112035.sptg2)
	e4:SetOperation(c101112035.spop2)
	c:RegisterEffect(e4)
end
function c101112035.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_SPELLCASTER)
end
function c101112035.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c101112035.spfilter(c,e,tp,targetp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,targetp) 
		and c:IsCanBeEffectTarget(e)
end
function c101112035.rescon(sg)
	return sg:GetCount()>1
end
function c101112035.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	local g1=Duel.GetMatchingGroup(c101112035.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,tp)
	local g2=Duel.GetMatchingGroup(c101112035.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,1-tp)
	if chk==0 then return ((#g1>1 and #g2>1) or (#(g1&g2)~=#g1 and #(g1&g2)~=#g2)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g1:Merge(g2)
	local tg=g1:SelectSubGroup(tp,c101112035.rescon,false,2,2)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,2,0,0)
end
function c101112035.spownfilter(c,e,tp,tg)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (tg-c):GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c101112035.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft1<=0 and ft2<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101112035,2))
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummonStep(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep((g-sg):GetFirst(),0,tp,1-tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
function c101112035.spcfilter(c)
	return c:IsReleasableByEffect() and (c:GetSequence()==2 or c:GetSequence()>4)
end
function c101112035.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101112035.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g==4 and Duel.GetMZoneCount(tp,g)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101112035.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101112035.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==4 and Duel.Release(g,REASON_EFFECT)==4 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end