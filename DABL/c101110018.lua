--銃の忍者－火光
function c101110018.initial_effect(c)
	--Special Summon 1 "Ninja" monster from hand or GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110018,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101110018)
	e1:SetTarget(c101110018.sptg)
	e1:SetOperation(c101110018.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	--Special Summon itself from the GY
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101110018,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,101110018+100)
	e4:SetCondition(c101110018.sspcon)
	e4:SetTarget(c101110018.ssptg)
	e4:SetOperation(c101110018.sspop)
	c:RegisterEffect(e4)
end
function c101110018.filter(c,e,tp)
	return c:IsSetCard(0x2b) and not c:IsCode(101110018) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c101110018.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101110018.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c101110018.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101110018.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101110018.sspcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or #tg~=1 then return false end
	local tc=tg:GetFirst()
	return tc:IsControler(tp) and tc:IsLocation(LOCATION_ONFIELD) and ((tc:IsSetCard(0x2b) and tc:IsFaceup()) or (tc:IsType(TYPE_MONSTER) and tc:IsPosition(POS_FACEDOWN_DEFENSE)))
		and tc:IsAbleToHand()
end
function c101110018.ssptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,tp,0)
end
function c101110018.sspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
		if tc:IsRelateToEffect(re) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end