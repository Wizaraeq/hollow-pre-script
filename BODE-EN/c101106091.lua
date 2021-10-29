--Beetrooper Squad
function c101106091.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106091,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101106091+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101106091.cost)
	e1:SetTarget(c101106091.target)
	e1:SetOperation(c101106091.activate)
	c:RegisterEffect(e1)
end
function c101106091.costfilter(c,tp)
	return c:IsRace(RACE_INSECT) and c:GetTextAttack()>=1000 and Duel.GetMZoneCount(tp,c)>0 and not c:IsType(TYPE_TOKEN)
end
function c101106091.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		return true
	end
end
function c101106091.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c101106091.costfilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local g=Duel.SelectReleaseGroup(tp,c101106091.costfilter,1,1,nil,tp)
	local atk=g:GetFirst():GetTextAttack()
	Duel.Release(g,REASON_COST)
	local ct=math.floor(atk/1000)
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c101106091.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetLabel()
	if ft>0 and ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,64213018,0x172,TYPES_TOKEN_MONSTER,1000,1000,3,RACE_INSECT,ATTRIBUTE_EARTH)then
		local count=math.min(ft,ct)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then count=1 end
		if count>1 then
			local num={}
			local i=1
			while i<=count do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101106091,1))
			count=Duel.AnnounceNumber(tp,table.unpack(num))
		end
		repeat
			local token=Duel.CreateToken(tp,101106191)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			count=count-1
		until count==0
		Duel.SpecialSummonComplete()
	end
end
