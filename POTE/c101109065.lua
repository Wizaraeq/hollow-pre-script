--Ｐ.Ｕ.Ｎ.Ｋ.ＪＡＭエクストリーム・セッション
function c101109065.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101109065,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101109065.spcost)
	e2:SetTarget(c101109065.sptg)
	e2:SetOperation(c101109065.spop)
	c:RegisterEffect(e2)
	-- Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101109065,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_PAY_LPCOST)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(2,101109065)
	e3:SetCondition(c101109065.drcon)
	e3:SetTarget(c101109065.drtg)
	e3:SetOperation(c101109065.drop)
	c:RegisterEffect(e3)
end
function c101109065.spcostfilter(c)
	return c:IsSetCard(0x171) and c:IsAbleToRemoveAsCost()
end
function c101109065.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101109065.spcostfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101109065.spcostfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101109065.spfilter(c,e,tp)
	return c:IsSetCard(0x171) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101109065.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101109065.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101109065.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101109065.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101109065.drcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	return ep==tp and loc==LOCATION_MZONE and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and tc:IsRace(RACE_PSYCHO) and tc:IsControler(tp)
end
function c101109065.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101109065.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end