--Ｇ・ボールパーク
function c101111062.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(101111062,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c101111062.actreg)
	c:RegisterEffect(e0)
	--Special Summon from your GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111062,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,101111062)
	e1:SetCondition(c101111062.spcon)
	e1:SetTarget(c101111062.sptg)
	e1:SetOperation(c101111062.spop)
	c:RegisterEffect(e1)
	--Switch control of 2 targets
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101111062,2))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101111062)
	e2:SetTarget(c101111062.ctrltg)
	e2:SetOperation(c101111062.ctrlop)
	c:RegisterEffect(e2)
end
function c101111062.actreg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(101111062,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c101111062.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101111062)>0
end
function c101111062.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101111062.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101111062.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101111062.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101111062.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101111062.rvlfilter(c,tp)
	return c:IsRace(RACE_INSECT) and c:IsAttackAbove(1) and not c:IsPublic()
		and Duel.IsExistingTarget(c101111062.filter1,tp,LOCATION_MZONE,0,1,nil,c:GetAttack())
end
function c101111062.rescon(sg,e,tp,mg)
	return sg:FilterCount(Card.IsControler,nil,tp)==1
end
function c101111062.filter1(c,atk,e)
	local tp=c:GetControler()
	return c:GetAttack()<atk and c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsAbleToChangeControler()
		and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
		and (not e or c:IsCanBeEffectTarget(e))
end
function c101111062.filter2(c,e)
	local tp=c:GetControler()
	return c:IsFaceup() and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
		and (not e or c:IsCanBeEffectTarget(e))
end
function c101111062.rescon(sg,e,tp,mg)
	return sg:FilterCount(Card.IsControler,nil,tp)==1
end
function c101111062.ctrltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c101111062.rvlfilter,tp,LOCATION_HAND,0,1,nil,tp)
		 and Duel.IsExistingTarget(c101111062.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101111062.rvlfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local atk=g:GetFirst():GetAttack()
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local g1=Duel.GetMatchingGroup(c101111062.filter1,tp,LOCATION_MZONE,0,nil,atk,e)
	local g2=Duel.GetMatchingGroup(c101111062.filter2,tp,0,LOCATION_MZONE,nil,e)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tg=g1:SelectSubGroup(tp,c101111062.rescon,false,2,2)
	Duel.SetTargetCard(tg)
	e:SetLabelObject(tg:Filter(Card.IsControler,nil,1-tp):GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tg,2,0,0)
end
function c101111062.ctrlop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #g~=2 then return end
	local a=g:GetFirst()
	local b=g:GetNext()
	if Duel.SwapControl(a,b) then
		local tc=e:GetLabelObject()
		if tc:IsControler(tp) and not tc:IsRace(RACE_INSECT) and tc:IsFaceup() then
			--Monster becomes Insect
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_INSECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end