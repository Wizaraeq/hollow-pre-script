--七皇覚醒
function c100428037.initial_effect(c)
	-- Special Summon 1 "Number C" monster from your Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100428037,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c100428037.condition)
	e1:SetTarget(c100428037.target)
	e1:SetOperation(c100428037.activate)
	c:RegisterEffect(e1)
end
function c100428037.cfilter(c)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c100428037.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100428037.cfilter,1,nil) and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c100428037.targetfilter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c100428037.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c100428037.spfilter(c,e,tp,xc)
	return c:IsSetCard(0x1048) and c:IsRace(xc:GetRace()) and c:IsRank(xc:GetRank()+1)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100428037.thfilter(c)
	return (not c:IsCode(100428037) and c:IsSetCard(0x175) and c:IsType(TYPE_SPELL+TYPE_TRAP))
		or (c:IsSetCard(0x176) and c:IsType(TYPE_SPELL+TYPE_TRAP))
		or (c:IsSetCard(0x95) and c:IsType(TYPE_QUICKPLAY))
end
function c100428037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.targetfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100428037.targetfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100428037.targetfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100428037.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c100428037.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
		if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) then
			Duel.Overlay(sc,tc,true)
			local no=aux.GetXyzNumber(sc)
			local g=Duel.GetMatchingGroup(c100428037.thfilter,tp,LOCATION_DECK,0,nil)
			if no and no>=101 and no<=107 and sc:IsSetCard(0x1048) 
				and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100428037,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end