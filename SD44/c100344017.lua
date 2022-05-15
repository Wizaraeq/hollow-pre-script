-- 宝玉の加護
function c100344017.initial_effect(c)
	-- Destroy Token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100344017,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100344017.destg)
	e1:SetOperation(c100344017.desop)
	c:RegisterEffect(e1)
	-- Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100344017,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_MOVE)
	e2:SetCountLimit(1,100344017)
	e2:SetCondition(c100344017.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100344017.sptg)
	e2:SetOperation(c100344017.spop)
	c:RegisterEffect(e2)
end
function c100344017.desfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1034) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100344117,0,TYPES_TOKEN_MONSTER,c:GetTextAttack(),c:GetTextDefense(),
			c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute())
end
function c100344017.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c100344017.desfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100344017.desfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100344017.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c100344017.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,100344117,0,TYPES_TOKEN_MONSTER,tc:GetTextAttack(),tc:GetTextDefense(),tc:GetOriginalLevel(),tc:GetOriginalRace(),tc:GetOriginalAttribute()) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,100344117)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			-- Change Type, Attribute, Level and ATK/DEF
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(tc:GetOriginalRace())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetValue(tc:GetOriginalAttribute())
			token:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_LEVEL)
			e3:SetValue(tc:GetOriginalLevel())
			token:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			e4:SetValue(math.max(0,tc:GetTextAttack()))
			token:RegisterEffect(e4,true)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_SET_BASE_DEFENSE)
			e5:SetValue(math.max(0,tc:GetTextDefense()))
			token:RegisterEffect(e5,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c100344017.spconfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1034) and c:IsLocation(LOCATION_SZONE) and not c:IsPreviousLocation(LOCATION_SZONE)
end
function c100344017.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c100344017.spconfilter,1,nil)
end
function c100344017.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1034) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100344017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100344017.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function c100344017.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100344017.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end