--冥骸府－メメントラン
function c100421008.initial_effect(c)
	-- Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- Prevent Spell/Trap activations during battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c100421008.aclimit)
	e1:SetCondition(c100421008.actcon)
	c:RegisterEffect(e1)
	-- Special Summon 1 "Memento" monster from your hand or GY 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100421008,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,100421008)
	e2:SetTarget(c100421008.sptg)
	e2:SetOperation(c100421008.spop)
	c:RegisterEffect(e2)
	-- Set 1 "Memento" Spell/Trap from your GY to your field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100421008,1))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100421008.setcon)
	e3:SetTarget(c100421008.settg)
	e3:SetOperation(c100421008.setop)
	c:RegisterEffect(e3)
end
function c100421008.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c100421008.actcon(e)
	local bc=Duel.GetBattleMonster(e:GetHandlerPlayer())
	return bc and bc:IsFaceup() and bc:IsSetCard(0x2a1)
end
function c100421008.spfilter(c,e,tp,tc)
	return c:IsSetCard(0x2a1) and c:IsLevelBelow(tc:GetLevel()-1)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
end
function c100421008.tcfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(c100421008.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c100421008.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c100421008.tcfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c100421008.tcfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=eg:FilterSelect(tp,c100421008.tcfilter,1,1,nil,e,tp):GetFirst()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c100421008.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100421008.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100421008.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100421008.setfilter(c)
	return c:IsSetCard(0x2a1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c100421008.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100421008.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100421008.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c100421008.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c100421008.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
	end
end