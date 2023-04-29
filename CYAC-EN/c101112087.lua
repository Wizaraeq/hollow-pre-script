--Gold Pride - Pin Baller
function c101112087.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,101112086,aux.FilterBoolFunction(Card.IsFusionSetCard,0x192),1,63,true,true)
	--Equip monsters the opponent controls to this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112087,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101112087)
	e1:SetLabel(101112087)
	e1:SetCondition(c101112087.eqcon)
	e1:SetTarget(c101112087.eqtg)
	e1:SetOperation(c101112087.eqop)
	c:RegisterEffect(e1)
	--Return itself to the Extra Deck and Special Summon "Gold Pride - Roller Baller"
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112087,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101112087.spcon)
	e2:SetTarget(c101112087.sptg)
	e2:SetOperation(c101112087.spop)
	c:RegisterEffect(e2)
	if not c101112087.global_check then
		c101112087.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_CANNOT_INACTIVATE)
		ge1:SetValue(c101112087.effectfilter)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EFFECT_CANNOT_DISEFFECT)
		Duel.RegisterEffect(ge2,0)
	end
end
function c101112087.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101112087.eqfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c101112087.effectfilter(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te:GetLabel()==101112087 and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c101112087.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetMaterialCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101112087.eqfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,1-tp,LOCATION_MZONE)
	--Register that this effect was activated this turn
	e:GetHandler():RegisterFlagEffect(101112087,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c101112087.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local ct=c:GetMaterialCount()
	local mt=math.min(ct,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c101112087.eqfilter,tp,0,LOCATION_MZONE,1,mt,nil)
	if #g>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c,true,false)
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetValue(c101112087.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		Duel.EquipComplete()
	end
end
function c101112087.eqlimit(e,c)
	return e:GetOwner()==c
end
function c101112087.spcon(e)
	return e:GetHandler():GetFlagEffect(101112087)>0
end
function c101112087.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101112087.spfilter(c,e,tp)
	return c:IsCode(101112086) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112087.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToExtra() and Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101112087.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end