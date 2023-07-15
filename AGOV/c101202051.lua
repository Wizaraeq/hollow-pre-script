--エクシーズ・エントラスト
function c101202051.initial_effect(c)
	--Add 1 "Armored Xyz" card from the Deck/GY to the hand and change the levels of up to 2 monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202051,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101202051+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101202051.thtg)
	e1:SetOperation(c101202051.thop)
	c:RegisterEffect(e1)
	--Special Summon 1 1 Xyz Monster treated as an Equip Card from your S/T Zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202051,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101202051.sptg)
	e2:SetOperation(c101202051.spop)
	c:RegisterEffect(e2)
end
function c101202051.thfilter(c)
	return c:IsSetCard(0x4073) and c:IsAbleToHand()
end
function c101202051.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101202051.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101202051.lvlfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and (c:GetLevel()~=3 or c:GetLevel()~=5)
end
function c101202051.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local thg=Duel.SelectMatchingCard(tp,c101202051.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #thg>0 and Duel.SendtoHand(thg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,thg)
		local g=Duel.GetMatchingGroup(c101202051.lvlfilter,tp,LOCATION_MZONE,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101202051,2)) then
			local ct=math.min(#g,2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local lvg=g:Select(tp,1,ct,nil)
			Duel.HintSelection(lvg)
			Duel.BreakEffect()
			local newlv
			if lvg:GetClassCount(Card.GetLevel)==1 then
				if lvg:GetFirst():GetLevel()==3 then newlv=5
				elseif lvg:GetFirst():GetLevel()==5 then newlv=3 
				else newlv=Duel.AnnounceNumber(tp,3,5) 
				end
			else
				newlv=Duel.AnnounceNumber(tp,3,5) 
			end
			for tc in aux.Next(lvg) do
				--Level becomes 3 or 5 until the End of this turn
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(newlv)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c101202051.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:GetOriginalType()&TYPE_XYZ>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101202051.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c101202051.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101202051.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101202051.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101202051.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end