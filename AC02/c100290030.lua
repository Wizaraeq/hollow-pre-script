--蚊学忍法・軍蚊マーチ
function c100290030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100290030,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100290030)
	e1:SetTarget(c100290030.sptg)
	e1:SetOperation(c100290030.spop)
	c:RegisterEffect(e1)
	 --Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100290030,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100290030+100)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c100290030.ctcon)
	e2:SetTarget(c100290030.cttg)
	e2:SetOperation(c100290030.ctop)
	c:RegisterEffect(e2)
end
function c100290030.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100290030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100290030.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100290030.regcon(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c100290030.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local ct=math.min(ft,2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local g=Duel.GetMatchingGroup(c100290030.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c100290030.regcon,false,1,ct)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100290030.cfilter(c)
	return c:IsCode(100290029) and c:IsFaceup()
end
function c100290030.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100290030.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100290030.ctfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c100290030.cpfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsCanAddCounter(0x1161,1)
end
function c100290030.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(c100290030.ctfilter,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x1161,1) end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(c100290030.cpfilter,tp,0,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100290030.cpfilter,tp,0,LOCATION_MZONE,1,ct,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1161)
end
function c100290030.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1161,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetCondition(c100290030.disable)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c100290030.disable(e)
	return e:GetHandler():GetCounter(0x1161)>0
end